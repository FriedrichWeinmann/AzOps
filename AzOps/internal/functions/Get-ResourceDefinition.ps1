﻿function Get-ResourceDefinition {
<#
	.SYNOPSIS
		This cmdlet recursively discovers resources (Management Groups, Subscriptions, Resource Groups, Resources, Policies, Role Assignments) from the provided input scope.
	
	.DESCRIPTION
		This cmdlet recursively discovers resources (Management Groups, Subscriptions, Resource Groups, Resources, Policies, Role Assignments) from the provided input scope.
	
	.PARAMETER Scope
		Discovery Scope
	
	.PARAMETER SkipPolicy
		Skip discovery of policies for better performance.
	
	.PARAMETER SkipRole
		Skip discovery of roles for better performance.
	
	.PARAMETER SkipResourceGroup
		Skip discovery of resource groups and resources for better performance.
	
	.PARAMETER ExportRawTemplate
		Export generic templates without embedding them in the parameter block.
	
	.PARAMETER StatePath
		The root folder under which to write the resource json.
	
	.EXAMPLE
		$TenantRootId = '/providers/Microsoft.Management/managementGroups/{0}' -f (Get-AzTenant).Id
		Get-ResourceDefinition -scope $TenantRootId -Verbose
		
		Discover all resources from root Management Group
	
	.EXAMPLE
		Get-ResourceDefinition -scope /providers/Microsoft.Management/managementGroups/landingzones -SkipPolicy -SkipResourceGroup
		
		Discover all resources from child Management Group, skip discovery of policies and resource groups
	
	.EXAMPLE
		Get-ResourceDefinition -scope /subscriptions/623625ae-cfb0-4d55-b8ab-0bab99cbf45c
		
		Discover all resources from Subscription level
	
	.EXAMPLE
		Get-ResourceDefinition -scope /subscriptions/623625ae-cfb0-4d55-b8ab-0bab99cbf45c/resourceGroups/myresourcegroup
		
		Discover all resources from resource group level
	
	.EXAMPLE
		Get-ResourceDefinition -scope /subscriptions/623625ae-cfb0-4d55-b8ab-0bab99cbf45c/resourceGroups/contoso-global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.database.windows.net
		
		Discover a single resource
#>
	[Alias('Get-AzOpsResourceDefinitionAtScope')]
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)]
		$Scope,
		
		[switch]
		$SkipPolicy,
		
		[switch]
		$SkipRole,
		
		[switch]
		$SkipResourceGroup,
		
		[switch]
		$ExportRawTemplate,
		
		[Parameter(Mandatory = $true)]
		[string]
		$StatePath
	)
	
	begin {
		#region Utility Functions
		function ConvertFrom-TypeResource {
			[CmdletBinding()]
			param (
				[Parameter(ValueFromPipeline = $true)]
				[AzOpsScope]
				$ScopeObject,
				
				[string]
				$StatePath,
				
				[switch]
				$ExportRawTemplate
			)
			
			process {
				$common = @{
					FunctionName = 'Get-ResourceDefinition'
					Target	     = $ScopeObject
				}
				
				Write-PSFMessage @common -String 'Get-ResourceDefinition.Resource.Processing' -StringValues $ScopeObject.Resource, $ScopeObject.ResourceGroup
				try {
					$resource = Get-AzResource -ResourceId $ScopeObject.scope -ErrorAction Stop
					ConvertTo-AzOpsState -Resource $resource -StatePath $StatePath -ExportRawTemplate:$ExportRawTemplate
				}
				catch {
					Write-PSFMessage @common -Level Warning -String 'Get-ResourceDefinition.Resource.Processing.Failed' -StringValues $ScopeObject.Resource, $ScopeObject.ResourceGroup -ErrorRecord $_
				}
			}
		}
		
		function ConvertFrom-TypeResourceGroup {
			[CmdletBinding()]
			param (
				[Parameter(ValueFromPipeline = $true)]
				[AzOpsScope]
				$ScopeObject,
				
				[string]
				$StatePath,
				
				[switch]
				$ExportRawTemplate,
				
				$Context,
				
				[string]
				$OdataFilter
			)
			
			process {
				$common = @{
					FunctionName = 'Get-ResourceDefinition'
					Target	     = $ScopeObject
				}
				
				Write-PSFMessage @common -String 'Get-ResourceDefinition.ResourceGroup.Processing' -StringValues $ScopeObject.Resourcegroup, $ScopeObject.SubscriptionDisplayName, $ScopeObject.Subscription
				
				try {
					$resourceGroup = Get-AzResourceGroup -Name $ScopeObject.ResourceGroup -DefaultProfile $Context -ErrorAction Stop
				}
				catch {
					Write-PSFMessage @common -Level Warning -String 'Get-ResourceDefinition.ResourceGroup.Processing.Error' -StringValues $ScopeObject.Resourcegroup, $ScopeObject.SubscriptionDisplayName, $ScopeObject.Subscription -ErrorRecord $_
					return
				}
				if ($resourceGroup.ManagedBy) {
					Write-PSFMessage @common -String 'Get-ResourceDefinition.ResourceGroup.Processing.Owned' -StringValues $resourceGroup.ResourceGroupName, $resourceGroup.ManagedBy
					return
				}
				ConvertTo-AzOpsState -Resource $resourceGroup -ExportRawTemplate:$ExportRawTemplate -StatePath $StatePath
				
				
				# Get all resources in resource groups
				$paramGetAzResource = @{
					DefaultProfile    = $Context
					ResourceGroupName = $resourceGroup.ResourceGroupName
					ODataQuery	      = $OdataFilter
					ExpandProperties  = $true
				}
				Get-AzResource @paramGetAzResource | ForEach-Object {
					New-AzOpsScope -Scope $_ -StatePath $StatePath
				} | ConvertFrom-TypeResource -StatePath $StatePath -ExportRawTemplate:$ExportRawTemplate
			}
		}
		
		function ConvertFrom-TypeSubscription {
			[CmdletBinding()]
			param (
				[Parameter(ValueFromPipeline = $true)]
				[AzOpsScope]
				$ScopeObject,
				
				[string]
				$StatePath,
				
				$Context,
				
				[switch]
				$ExportRawTemplate,
				
				[switch]
				$SkipResourceGroup,
				
				[string]
				$ODataFilter
			)
			
			begin {
				# Set variables for retry with exponential backoff
				$backoffMultiplier = 2
				$maxRetryCount = 6
			}
			
			process {
				$common = @{
					FunctionName = 'Get-ResourceDefinition'
					Target	     = $ScopeObject
				}
				
				Write-PSFMessage @common -String 'Get-ResourceDefinition.Subscription.Processing' -StringValues $ScopeObject.SubscriptionDisplayName, $ScopeObject.Subscription
				
				# Skip discovery of resource groups if SkipResourceGroup switch have been used
				# Separate discovery of resource groups in subscriptions to support parallel discovery
				if ($SkipResourceGroup) {
					Write-PSFMessage @common -String 'Get-ResourceDefinition.Subscription.SkippingResourceGroup'
				}
				else {
					# Get all Resource Groups in Subscription
					# Retry loop with exponential backoff implemented to catch errors
					# Introduced due to error "Your Azure Credentials have not been set up or expired"
					# https://github.com/Azure/azure-powershell/issues/9448
					# Define variables used by script
					$resourceGroups = Invoke-ScriptBlock -ArgumentList $Context -ScriptBlock {
						param ($Context)
						Get-AzResourceGroup -DefaultProfile ($Context | Write-Output) -ErrorAction Stop | Where-Object { -not $_.ManagedBy }
					} -RetryCount $maxRetryCount -RetryWait $backoffMultiplier -RetryType Exponential
					if (-not $resourceGroups) {
						Write-PSFMessage @common -String 'Get-ResourceDefinition.Subscription.NoResourceGroup' -StringValues $ScopeObject.SubscriptionDisplayName, $ScopeObject.Subscription
					}
					
					#region Prepare Input Data for parallel processing
					$runspaceData = @{
						AzOpsPath = "$($script:ModuleRoot)\AzOps.psd1"
						StatePath = $StatePath
						ScopeObject = $ScopeObject
						ODataFilter = $ODataFilter
						MaxRetryCount = $maxRetryCount
						BackoffMultiplier = $backoffMultiplier
						ExportRawTemplate = $ExportRawTemplate
					}
					#endregion Prepare Input Data for parallel processing
					
					#region Discover all resource groups in parallel
					$resourceGroups | Foreach-Object -ThrottleLimit (Get-PSFConfigValue -FullName 'AzOps.General.ThrottleLimit') -Parallel {
						$resourceGroup = $_
						$runspaceData = $using:runspaceData
						
						$msgCommon = @{
							FunctionName = 'Get-ResourceDefinition'
							ModuleName   = 'AzOps'
						}
						
						# region Importing module
						# We need to import all required modules and declare variables again because of the parallel runspaces
						# https://devblogs.microsoft.com/powershell/powershell-foreach-object-parallel-feature/
						Import-Module "$([PSFramework.PSFCore.PSFCoreHost]::ModuleRoot)\psframework.psd1"
						$azOps = Import-Module $runspaceData.AzOpsPath -Force -PassThru
						# endregion Importing module
						
						$context = Get-AzContext -ListAvailable | Where-Object {
							$_.Subscription.id -eq $runspaceData.ScopeObject.Subscription
						}
						
						Write-PSFMessage @msgCommon -String 'Get-ResourceDefinition.SubScription.Processing.ResourceGroup' -StringValues $resourceGroup.ResourceGroupName -Target $resourceGroup
						& $azOps { ConvertTo-AzOpsState -Resource $resourceGroup -ExportRawTemplate:$runspaceData.ExportRawTemplate -StatePath $runspaceData.Statepath }
						
						Write-PSFMessage @msgCommon -String 'Get-ResourceDefinition.SubScription.Processing.ResourceGroup.Resources' -StringValues $resourceGroup.ResourceGroupName -Target $resourceGroup
						$resources = & $azOps {
							Invoke-ScriptBlock -ArgumentList $Context, $resourceGroup, $runspaceData.ODataFilter -ScriptBlock {
								param (
									$Context,
									
									$ResourceGroup,
									
									$ODataFilter
								)
								Get-AzResource -DefaultProfile $Context -ResourceGroupName $ResourceGroup.ResourceGroupName -ODataQuery $ODataFilter -ExpandProperties -ErrorAction Stop
							} -RetryCount $runspaceData.MaxRetryCount -RetryWait $runspaceData.BackoffMultiplier -RetryType Exponential
						}
						if (-not $resources) {
							Write-PSFMessage @msgCommon -Level Warning -String 'Get-ResourceDefinition.SubScription.Processing.ResourceGroup.NoResources' -StringValues $resourceGroup.ResourceGroupName -Target $resourceGroup
						}
						
						# Loop through resources and convert them to AzOpsState
						foreach ($resource in $resources) {
							# Convert resources to AzOpsState
							Write-PSFMessage @msgCommon -String 'Get-ResourceDefinition.SubScription.Processing.Resource' -StringValues $resource.Name, $resourceGroup.ResourceGroupName -Target $resource
							& $azOps { ConvertTo-AzOpsState -Resource $resource -ExportRawTemplate:$runspaceData.ExportRawTemplate -StatePath $runspaceData.Statepath }
						}
					}
					#endregion Discover all resource groups in parallel
				}
				if ($subscriptionItem = $script:AzOpsAzManagementGroup.children | Where-Object Name -eq $ScopeObject.name) {
					ConvertTo-AzOpsState -Resource $subscriptionItem -ExportRawTemplate:$ExportRawTemplate -StatePath $StatePath
				}
			}
		}
		
		function ConvertFrom-TypeManagementGroup {
			[CmdletBinding()]
			param (
				[Parameter(ValueFromPipeline = $true)]
				[AzOpsScope]
				$ScopeObject,
				
				[switch]
				$SkipPolicy,
				
				[switch]
				$SkipRole,
				
				[switch]
				$SkipResourceGroup,
				
				[switch]
				$ExportRawTemplate,
				
				[string]
				$StatePath
			)
			begin {
				$parameters = $PSBoundParameters | ConvertTo-PSFHashtable -Exclude ScopeObject
			}
			process {
				$common = @{
					FunctionName = 'Get-ResourceDefinition'
					Target	     = $ScopeObject
				}
				
				Write-PSFMessage -String 'Get-ResourceDefinition.ManagementGroup.Processing' -StringValues $ScopeObject.ManagementGroupDisplayName, $ScopeObject.ManagementGroup
				
				$childOfManagementGroups = ($script:AzOpsAzManagementGroup | Where-Object Name -eq $ScopeObject.ManagementGroup).Children
				
				foreach ($child in $childOfManagementGroups) {
					Get-ResourceDefinition -Scope $child.Id @parameters
				}
				ConvertTo-AzOpsState -Resource ($script:AzOpsAzManagementGroup | Where-Object Name -eq $ScopeObject.ManagementGroup) -ExportRawTemplate:$ExportRawTemplate -StatePath $StatePath
			}
		}
		#endregion Utility Functions
	}
	process {
		Write-PSFMessage -String 'Get-ResourceDefinition.Processing' -StringValues $Scope
		
		try { $scopeObject = New-AzOpsScope -Scope $Scope -StatePath $StatePath -ErrorAction Stop }
		catch {
			Write-PSFMessage -String 'Get-ResourceDefinition.Processing.NotFound' -StringValues $Scope
			return
		}
		
		if ($scopeObject.Subscription) {
			Write-PSFMessage -String 'Get-ResourceDefinition.Subscription.Found' -StringValues $scopeObject.subscriptionDisplayName, $scopeObject.subscription
			$context = Get-AzContext -ListAvailable | Where-Object { $_.Subscription.id -eq $scopeObject.Subscription }
			$odataFilter = "`$filter=subscriptionId eq '$($scopeObject.subscription)'"
			Write-PSFMessage -Level Debug -String 'Get-ResourceDefinition.Subscription.OdataFilter' -StringValues $odataFilter
		}
		
		switch ($scopeObject.Type) {
			resource { ConvertFrom-TypeResource -ScopeObject $scopeObject -StatePath $StatePath -ExportRawTemplate:$ExportRawTemplate }
			resourcegroups { ConvertFrom-TypeResourceGroup -ScopeObject $scopeObject -StatePath $StatePath -ExportRawTemplate:$ExportRawTemplate -Context $context -OdataFilter $odataFilter }
			subscriptions { ConvertFrom-TypeSubscription -ScopeObject $scopeObject -StatePath $StatePath -ExportRawTemplate:$ExportRawTemplate -Context $context -SkipResourceGroup:$SkipResourceGroup -ODataFilter $odataFilter }
			managementGroups { ConvertFrom-TypeManagementGroup -ScopeObject $scopeObject -StatePath $StatePath -ExportRawTemplate:$ExportRawTemplate -SkipPolicy:$SkipPolicy -SkipRole:$SkipRole -SkipResourceGroup:$SkipResourceGroup }
		}
		
		if ($scopeObject.Type -notin 'resourcegroups', 'subscriptions', 'managementgroups') {
			Write-PSFMessage -String 'Get-ResourceDefinition.Finished' -StringValues $scopeObject.Scope
			return
		}
		
		$serializedPolicyDefinitionsInAzure = @()
		$serializedPolicySetDefinitionsInAzure = @()
		$serializedPolicyAssignmentsInAzure = @()
		$serializedRoleDefinitionsInAzure = @()
		$serializedRoleAssignmentInAzure = @()
		
		#region Process Policies
		if (-not $SkipPolicy) {
			# Process policy definitions
			Write-PSFMessage -String 'Get-ResourceDefinition.Processing.Detail' -StringValues 'Policy Definitions', $scopeObject.Scope
			$policyDefinitions = Get-PolicyDefinition -ScopeObject $scopeObject
			$policyDefinitions | ConvertTo-AzOpsState -ExportRawTemplate:$ExportRawTemplate -StatePath $StatePath
			$serializedPolicyDefinitionsInAzure = $policyDefinitions | ConvertTo-AzOpsState -ExportRawTemplate -StatePath $StatePath -ReturnObject
			
			# Process policyset definitions (initiatives))
			Write-PSFMessage -String 'Get-ResourceDefinition.Processing.Detail' -StringValues 'PolicySet Definitions', $scopeObject.Scope
			$policySetDefinitions = Get-PolicySetDefinition -ScopeObject $scopeObject
			$policySetDefinitions | ConvertTo-AzOpsState -ExportRawTemplate:$ExportRawTemplate -StatePath $StatePath
			$serializedPolicySetDefinitionsInAzure = $policySetDefinitions | ConvertTo-AzOpsState -ExportRawTemplate -StatePath $StatePath -ReturnObject
			
			# Process policy assignments
			Write-PSFMessage -String 'Get-ResourceDefinition.Processing.Detail' -StringValues 'Policy Assignments', $scopeObject.Scope
			$policyAssignments = Get-PolicyAssignment -ScopeObject $scopeObject
			$policyAssignments | ConvertTo-AzOpsState -ExportRawTemplate:$ExportRawTemplate -StatePath $StatePath
			$serializedPolicyAssignmentsInAzure = $policyAssignments | ConvertTo-AzOpsState -ExportRawTemplate -StatePath $StatePath -ReturnObject
		}
		#endregion Process Policies
		#region Process Roles
		if (-not $SkipRole) {
			# Process role definitions
			Write-PSFMessage -String 'Get-ResourceDefinition.Processing.Detail' -StringValues 'Role Definitions', $scopeObject.Scope
			$roleDefinitions = Get-RoleDefinition -ScopeObject $scopeObject
			$roleDefinitions | ConvertTo-AzOpsState -ExportRawTemplate:$ExportRawTemplate -StatePath $StatePath
			$serializedRoleDefinitionsInAzure = $roleDefinitions | ConvertTo-AzOpsState -ExportRawTemplate -StatePath $StatePath -ReturnObject
			
			# Process role assignments
			Write-PSFMessage -String 'Get-ResourceDefinition.Processing.Detail' -StringValues 'Role Assignments', $scopeObject.Scope
			$roleAssignments = Get-RoleAssignment -ScopeObject $scopeObject
			$roleAssignments | ConvertTo-AzOpsState -ExportRawTemplate:$ExportRawTemplate -StatePath $StatePath
			$serializedRoleAssignmentInAzure = $roleAssignments | ConvertTo-AzOpsState -ExportRawTemplate -StatePath $StatePath -ReturnObject
		}
		#endregion Process Roles
		
		if ($scopeObject.Type -notin 'subscriptions', 'managementgroups') {
			Write-PSFMessage -String 'Get-ResourceDefinition.Finished' -StringValues $scopeObject.Scope
			return
		}
		
		#region Add accumulated policy and role data
		# Get statefile from scope
		$parametersJson = Get-Content -Path $scopeObject.StatePath | ConvertFrom-Json -Depth 100
		# Create property bag and add resources at scope
		$propertyBag = [ordered]@{
			'policyDefinitions' = @($serializedPolicyDefinitionsInAzure)
			'policySetDefinitions' = @($serializedPolicySetDefinitionsInAzure)
			'policyAssignments' = @($serializedPolicyAssignmentsInAzure)
			'roleDefinitions'   = @($serializedRoleDefinitionsInAzure)
			'roleAssignments'   = if (Get-PSFConfigValue -FullName 'AzOps.General.GeneralizeTemplates') {
				 , @()
			} else {
				 , @($serializedRoleAssignmentInAzure)
			}
		}
		# Add property bag to parameters json
		$parametersJson.parameters.input.value | Add-Member -Name 'properties' -MemberType NoteProperty -Value $propertyBag -force
		# Export state file with properties at scope
		ConvertTo-AzOpsState -Resource $parametersJson -ExportPath $scopeObject.StatePath -ExportRawTemplate -StatePath $StatePath
		#endregion Add accumulated policy and role data
		
		Write-PSFMessage -String 'Get-ResourceDefinition.Finished' -StringValues $scopeObject.Scope
	}
}