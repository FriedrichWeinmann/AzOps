﻿# This is where the strings go, that are written by
# Write-PSFMessage, Stop-PSFFunction or the PSFramework validation scriptblocks
@{
	'Assert-AzOpsInitialization.NoCache'									   = 'The cache of existing Management Groups and subscriptions has not yet been built! Run Initialize-AzOpsEnvironment to build it.' # 
	'Assert-AzOpsInitialization.StateError'								       = 'The state path offered contains invalid characters and cannot be used in the current filesystem' # 
	
	'Assert-WindowsLongPath.Validating'									       = 'Validating Windows environment for LongPath support'
	'Assert-WindowsLongPath.No.GitCfg'										   = 'Git has not been configured for long path support' # 
	'Assert-WindowsLongPath.No.Registry'									   = 'Windows has not yet been configured for long path support' # 
	'Assert-WindowsLongPath.Failed'										       = 'Windows not sufficiently configured for long paths! Follow instructions for "Enabling long paths on Windows" on https://aka.ms/es/quickstart.'
	
	'ConvertTo-AzOpsState.Starting'										       = 'Starting conversion to AzOps State object' #
	'ConvertTo-AzOpsState.StateConfig.Error'								   = 'Cannot load {0}, is the json schema valid and does the file exist?' # Get-PSFConfigValue -FullName 'AzOps.General.StateConfig'
	'ConvertTo-AzOpsState.StatePath'										   = 'Resolve path to resource state: {0}' # $resourceData.ObjectFilePath
	'ConvertTo-AzOpsState.ExcludedProperties'								   = 'Default excluded properties: [{0}]' # ($excludedProperties.Keys -join ', ')
	'ConvertTo-AzOpsState.ObjectType.Resolved'								   = 'Found object type: {0}'
	'ConvertTo-AzOpsState.ObjectType.Resolved.Generic'						   = 'Generic object detected, ExportPath expected'
	'ConvertTo-AzOpsState.ResourceError'									   = 'Error processing resource: {0}' # $Resource
	'ConvertTo-AzOpsState.NoExportPath'									       = 'No export path found for {0}. Ensure the original data type remains intact or specify an -ExportPath' # $Resource
	'ConvertTo-AzOpsState.Processing'										   = 'Processing input: {0}' # $Resource
	'ConvertTo-AzOpsState.File.Create'										   = 'AzOpsState file not found. Creating new: {0}' # $resourceData.ObjectFilePath
	'ConvertTo-AzOpsState.Generalized.ExcludedProperties'					   = 'GeneralizeTemplates used: Excluded properties: [{0}]' # ($excludedProperties.Keys -join ', ')
	'ConvertTo-AzOpsState.Generalized.Exporting'							   = 'Exporting AzOpsState to: {0}' # $originalFilePath
	'ConvertTo-AzOpsState.Exporting'										   = 'Exporting AzOpsState to {0}' # $resourceData.ObjectFilePath
	'ConvertTo-AzOpsState.Object.ReOrder'									   = 'Updating state object content order' #
	
	'Get-PolicyAssignment.ManagementGroup'									   = 'Retrieving Policy Assignment for Management Group {0} ({1})' # $ScopeObject.ManagementGroupDisplayName, $ScopeObject.ManagementGroup
	'Get-PolicyAssignment.ResourceGroup'									   = 'Retrieving Policy Assignment for Resource Group {0}' # $ScopeObject.ResourceGroup
	'Get-PolicyAssignment.Subscription'									       = 'Retrieving Policy Assignment for Subscription {0} ({1})' # $ScopeObject.SubscriptionDisplayName, $ScopeObject.Subscription
	
	'Get-PolicyDefinition.ManagementGroup'									   = 'Retrieving custom policy definitions for Management Group [{0}] ({1})' # $ScopeObject.ManagementGroupDisplayName, $ScopeObject.ManagementGroup
	'Get-PolicyDefinition.Subscription'									       = 'Retrieving custom policy definitions for Subscription [{0}] ({1})' # $ScopeObject.SubscriptionDisplayName, $ScopeObject.Subscription
	
	'Get-PolicySetDefinition.ManagementGroup'								   = 'Retrieving PolicySet Definition for ManagementGroup {0} ({1})' # $ScopeObject.ManagementGroupDisplayName, $ScopeObject.ManagementGroup
	'Get-PolicySetDefinition.Subscription'									   = 'Retrieving PolicySet Definition for Subscription {0} ({1})' # $ScopeObject.SubscriptionDisplayName, $ScopeObject.Subscription
	
	'Get-ResourceDefinition.Processing'									       = 'Processing scope: [{0}]' # $Scope
	'Get-ResourceDefinition.Processing.NotFound'							   = 'Scope [{0}] not found in Azure or it is excluded' # $Scope
	'Get-ResourceDefinition.Subscription.Found'							       = 'Found Subscription: {0} ({1})' # $scopeObject.subscriptionDisplayName, $scopeObject.subscription
	'Get-ResourceDefinition.Subscription.OdataFilter'						   = 'Setting Odatafilter: {0}' # $odataFilter
	'Get-ResourceDefinition.Resource.Processing'							   = 'Processing Resource [{0}] in Resource Group [{1}]' # $ScopeObject.resource, $ScopeObject.resourcegroup
	'Get-ResourceDefinition.Resource.Processing.Failed'					       = 'Unable to process Resource [{0}] in Resource Group [{1]' # $ScopeObject.resource, $ScopeObject.resourcegroup
	'Get-ResourceDefinition.ResourceGroup.Processing'						   = 'Processing Resource Group [{0}] in Subscription [{1}] ({2})' # $ScopeObject.Resourcegroup, $ScopeObject.SubscriptionDisplayName, $ScopeObject.Subscription
	'Get-ResourceDefinition.ResourceGroup.Processing.Error'				       = 'Failed to access Resource Group [{0}] in Subscription [{1}] ({2})' # $ScopeObject.Resourcegroup, $ScopeObject.SubscriptionDisplayName, $ScopeObject.Subscription
	'Get-ResourceDefinition.ResourceGroup.Processing.Owned'				       = 'Skipping {0} as it is managed by {1}' # $resourceGroup.ResourceGroupName, $resourceGroup.ManagedBy
	'Get-ResourceDefinition.Subscription.Processing'						   = 'Processing Subscription [{0}] ({1})' # $ScopeObject.SubscriptionDisplayName, $ScopeObject.Subscription
	'Get-ResourceDefinition.Subscription.SkippingResourceGroup'			       = 'SkipResourceGroup switch used, skipping Resource Group discovery' # 
	'Get-ResourceDefinition.Subscription.NoResourceGroup'					   = 'No non-managed Resource Group found in Subscription [{0}] ({1})' # $ScopeObject.SubscriptionDisplayName, $ScopeObject.Subscription
	'Get-ResourceDefinition.SubScription.Processing.ResourceGroup'			   = 'Processing Resource Group [{0}]' # $resourceGroup.ResourceGroupName
	'Get-ResourceDefinition.SubScription.Processing.ResourceGroup.Resources'   = 'Searching for resources in Resource Group [{0}]' # $resourceGroup.ResourceGroupName
	'Get-ResourceDefinition.SubScription.Processing.ResourceGroup.NoResources' = 'No resources found in Resource Group [{0}]' # $resourceGroup.ResourceGroupName
	'Get-ResourceDefinition.SubScription.Processing.Resource'				   = 'Processing Resource [{0}] in Resource Group [{1}]' # $resource.Name, $resourceGroup.ResourceGroupName
	'Get-ResourceDefinition.ManagementGroup.Processing'					       = 'Processing Management Group [{0}] ({1})' # $ScopeObject.ManagementGroupDisplayName, $ScopeObject.ManagementGroup
	'Get-ResourceDefinition.Finished'										   = 'Finished processing scope [{0}]' # $scopeObject.Scope
	'Get-ResourceDefinition.Processing.Detail'								   = 'Processing detail: {0} for [{1}]' # 'Policy Definitions', $scopeObject.Scope
	
	'Get-RoleAssignment.Processing'										       = 'Retrieving Role Assignments at scope {0}' # $ScopeObject
	'Get-RoleAssignment.Assignment'										       = 'Found assignment {0} for role {1}' # $roleAssignment.DisplayName, $roleAssignment.RoleDefinitionName
	
	'Get-RoleDefinition.Processing'										       = 'Processing {0}' # $ScopeObject
	'Get-RoleDefinition.NonAuthorative'									       = 'Role Definition {0} exists at {1} however it is not authoritative. Current authoritative scope is {2}' # $roledefinition,Id, $ScopeObject.Scope, $roledefinition.AssignableScopes[0]
	
	'Get-Subscription.Excluded.Offers'										   = 'Excluded subscription offers: {0}' # ($ExcludedOffers -join ',')
	'Get-Subscription.Excluded.States'										   = 'Excluded subscription states: {0}' # ($ExcludedStates -join ',')
	'Get-Subscription.NoSubscriptions'										   = 'No relevant subscriptions found!' # 
	'Get-Subscription.Subscriptions.Excluded'								   = 'Number of subscriptions excluded: {0}' # ($allSubscriptionsResults.Count - $includedSubscriptions.Count)
	'Get-Subscription.Subscriptions.Found'									   = 'Number of subscriptions found: {0}' # $allSubscriptionsResults.Count
	'Get-Subscription.Subscriptions.Included'								   = 'Number of subscriptions included: {0}' # $includedSubscriptions.Count
	'Get-Subscription.Subscriptions.PastDue'								   = 'Number of included subscriptions in the state "PastDue": {0}' # ($includedSubscriptions | Where-Object State -EQ PastDue).Count
	
	'Initialize-AzOpsEnvironment.AzureContext.No'							   = 'No context available in Az PowerShell. Please use Connect-AzAccount and connect before using the command'
	'Initialize-AzOpsEnvironment.AzureContext.TooMany'						   = 'Unsupported number of tenants in context: {0} TenantIDs
TenantIDs: {1}
Please reconnect with Connect-AzAccount using an account/service principal that only have access to one tenant' # $azContextTenants.Count, ($azContextTenants -join ',')
	'Initialize-AzOpsEnvironment.UsingCache'								   = 'Using cached values for AzOpsAzManagementGroup and AzOpsSubscriptions'
	'Initialize-AzOpsEnvironment.Initializing'								   = 'Starting AzOps environment initialization' # 
	'Initialize-AzOpsEnvironment.ManagementGroup.Expanding'					   = 'Expanding management groups under {0}' # $mgmtGroup.Name
	'Initialize-AzOpsEnvironment.ManagementGroup.NotFound'					   = 'Root path {0} not found with account {1}. Ensure you have root access or use partial discovery.' # $rootScope, (Get-AzContext).Account.Id
	'Initialize-AzOpsEnvironment.ManagementGroup.PartialDiscovery'			   = 'Executing partial discovery' # 
	'Initialize-AzOpsEnvironment.ManagementGroup.Resolution'				   = 'Resolving {0} management groups' # $managementGroups.Count
	'Initialize-AzOpsEnvironment.Processing'								   = 'Processing AzOps environment' # 
	'Initialize-AzOpsEnvironment.Processing.Completed'						   = 'AzOps environment initialization concluded' # 
	
	'Initialize-AzOpsRepository.Deleting.State'							       = 'Removing state in {0}' # $StatePath
	'Initialize-AzOpsRepository.Duration'									   = 'AzOps repository setup completed in {0}' # $stopWatch.Elapsed
	'Initialize-AzOpsRepository.Initialization.Completed'					   = 'Completed preparations for the AzOps repository setup' # 
	'Initialize-AzOpsRepository.Initialization.Starting'					   = 'Starting preparations for the AzOps repository setup' # 
	'Initialize-AzOpsRepository.ManagementGroup.AccessError'				   = 'Cannot access root management group {0} - verify that principal {1} has access' # $root, (Get-AzContext).Account.Id
	'Initialize-AzOpsRepository.Migration.Required'						       = 'Migration from previous repository state IS required' # 
	'Initialize-AzOpsRepository.Rebuilding.State'							   = 'Rebuilding state in {0}' # $StatePath
	'Initialize-AzOpsRepository.Tenant'									       = 'Connected to tenant {0}' # $tenantId
	'Initialize-AzOpsRepository.Validating.UserRole'						   = 'Asserting fundamental azure access' # 
	'Initialize-AzOpsRepository.Validating.UserRole.Failed'				       = 'Insufficient access to azure user data!' # 
	'Initialize-AzOpsRepository.Validating.UserRole.Success'				   = 'Azure Access validated' # 
	
	'Invoke-AzOpsChange.Deployment.Required'								   = 'Deployment required' #
	'Invoke-AzOpsChange.Change.AddModify'									   = 'Adding or modifying:' #
	'Invoke-AzOpsChange.Change.AddModify.File'								   = '  {0}' # $item
	'Invoke-AzOpsChange.Change.Delete'										   = 'Deleting:' #
	'Invoke-AzOpsChange.Change.Delete.File'								       = '  {0}' # $item
	'Invoke-AzOpsChange.Deploy.Subscription'								   = 'Invoking new state deployment - *.subscription.json for a file {0}' # $addition
	'Invoke-AzOpsChange.Deploy.ProviderFeature'							       = 'Invoking new state deployment - *.providerfeatures.json for a file {0}' # $addition
	'Invoke-AzOpsChange.Deploy.ResourceProvider'							   = 'Invoking new state deployment - *.resourceproviders.json for a file {0}' # $addition
	'Invoke-AzOpsChange.Scope.Failed'										   = 'Failed to read {0} as part of {1}' # $addition, $StatePath
	'Invoke-AzOpsChange.Scope.NotFound'									       = 'Skipping {0}, not part of {1}' # $addition, $StatePath
	'Invoke-AzOpsChange.Resolve.NoJson'									       = 'The specified file is not a json file at all! Skipping {0}' # $fileItem.FullName
	'Invoke-AzOpsChange.Resolve.FoundTemplate'								   = 'Found template {1} for parameters {0}' # $FilePath, $templatePath
	'Invoke-AzOpsChange.Resolve.NotFoundTemplate'							   = 'Did NOT find template {1} for parameters {0}' # $FilePath, $templatePath
	'Invoke-AzOpsChange.Resolve.FromMainTemplate'							   = 'Determining template from main template file: {0}' # $mainTemplateItem.FullName
	'Invoke-AzOpsChange.Resolve.MainTemplate.Supported'					       = 'effectiveResourceType: {0} - AzOpsMainTemplate supports resource type {0} in {1}' # $effectiveResourceType, $AzOpsMainTemplate.FullName
	'Invoke-AzOpsChange.Resolve.MainTemplate.NotSupported'					   = 'effectiveResourceType: {0} AzOpsMainTemplate does NOT supports resource type {0} in {1}. Deployment will be ignored' # $effectiveResourceType, $AzOpsMainTemplate.FullName
	'Invoke-AzOpsChange.Resolve.ParameterFound'							       = 'Found parameter file for template {0} : {1}' # $FilePath, $parameterPath
	'Invoke-AzOpsChange.Resolve.ParameterNotFound'							   = 'No parameter file found for template {0} : {1}' # $FilePath, $parameterPath
	
	'Invoke-AzOpsGitPull.Fetching'											   = 'Fetching latest changes' # 
	'Invoke-AzOpsGitPull.CheckingOut'										   = 'Checking for branch (system)' # 
	'Invoke-AzOpsGitPull.CheckingOut.Exists'								   = 'Checking out existing branch (system)' #
	'Invoke-AzOpsGitPull.CheckingOut.New'									   = 'Checking out new branch (system)' #
	'Invoke-AzOpsGitPull.Initialize.Repository'							       = 'Executing repository initialization'
	
	'Invoke-NativeCommand.Failed.WithCallstack'							       = 'Execution of {{{0}}} by {1}: line {2} failed with exit code {3}'
	'Invoke-NativeCommand.Failed.NoCallstack'								   = 'Execution of {{{0}}} failed with exit code {1}'
	
	'Invoke-ScriptBlock.Failed.GivingUp'									   = 'Tried unsuccessfully {0} out of {1} times, giving up.' # $count, $RetryCount
	'Invoke-ScriptBlock.Failed.WillRetry'									   = 'Tried unsuccessfully {0} out of {1} times, keeping up the fight!' # $count, $RetryCount
	
	'New-AzOpsScope.Starting'												   = 'Starting creation of new scope object' #
	'New-AzOpsScope.Creating.FromScope'									       = 'Creating new AzOpsScope object using scope [{0}]' # $Scope
	'New-AzOpsScope.Path.NotFound'											   = 'Path not found: {0}' # Path
	'New-AzOpsScope.Path.InvalidRoot'										   = 'Path "{0}" must be a path under "{1}" !' # $Path, $StatePath
	'New-AzOpsScope.Creating.FromFile'										   = 'Creating a new scope from a path' #
	
	'New-Deployment.Processing'											       = 'Processing deployment {0} for template {1} with parameter "{2}" in mode {3}' # $DeploymentName, $TemplateFilePath, $TemplateParameterFilePath, $Mode
	'New-Deployment.Scope.Failed'											   = 'Failed to resolve the scope for template {0} and parameters {1}' # $TemplateFilePath, $TemplateParameterFilePath 
	'New-Deployment.Scope.Empty'											   = 'Unable to determine the scope of template {0} and parameters {1}' # $TemplateFilePath, $TemplateParameterFilePath 
	'New-Deployment.ResourceGroup.Processing'								   = 'Attempting [Resource Group] deployment for {0}' #  $scopeObject
	'New-Deployment.TemplateError'											   = 'Error validating template: {0}' # $TemplateFilePath
	'New-Deployment.Subscription.Processing'								   = 'Attempting [Subscription] deployment in [{0}] for {1}' # $defaultDeploymentRegion, $scopeObject
	'New-Deployment.ManagementGroup.Processing'							       = 'Attempting [Management Group] deployment in [{0}] for {1}' # $defaultDeploymentRegion, $scopeObject
	'New-Deployment.Root.Processing'										   = 'Attempting [Tenant Scope] deployment in [{0}] for {1}' # $defaultDeploymentRegion, $scopeObject
	
	'New-Deployment.Scope.Unidentified'									       = 'Unable to determine to scope type for this Az deployment : {0}' # $scopeObject
	
	'New-StateDeployment.Processing'										   = 'Processing new state deployment for {0}' # $FileName
	'New-StateDeployment.InvalidScope'										   = 'Unable to determine scope type for {0}, skipping' # $FileName
	'New-StateDeployment.Subscription'										   = 'Upserting subscriptions for {0}' # $FileName
	'New-StateDeployment.Subscription.New'									   = 'Creating new subscription for {0}' # $FileName
	'New-StateDeployment.NoEnrollmentAccount'								   = 'No Azure Enrollment account found for current Azure context' #
	'New-StateDeployment.NoEnrollmentAccount.Solution'						   = 'Create new Azure role assignment for service principal used for pipeline: New-AzRoleAssignment -ObjectId <application-Id> -RoleDefinitionName Owner -Scope /providers/Microsoft.Billing/enrollmentAccounts/<object-Id>' #
	'New-StateDeployment.EnrollmentAccount.Selected'						   = 'Using the defined enrollment account {0}' # $AzOpsEnrollmentAccountPrincipalName
	'New-StateDeployment.EnrollmentAccount.First'							   = 'No enrollment account defined, using the first account found: {0}' # @($enrollmentAccounts)[0].PrincipalName
	'New-StateDeployment.Subscription.Creating'							       = 'Creating new subscription: {0}' # $scopeObject.Name
	'New-StateDeployment.Subscription.AssignManagementGroup'				   = 'Assigning subscription {0} to management group {1}' # $subscription.Name, $scopeObject.ManagementGroupDisplayName
	'New-StateDeployment.Subscription.Exists'								   = 'Existing subscription found: {0} ({1})' # $subscription.Name, $subscription.Id
	
	'Register-ProviderFeature.Processing'									   = 'Processing provider feature {0} from {1}' # $ScopeObject, $FileName
	'Register-ProviderFeature.Context.Switching'							   = 'Switching Subscription context from {0}/{1} to {2}/{3}' # $currentContext.Subscription.Name, $CurrentAzContext.Subscription.Id, $ScopeObject.Subscription, $ScopeObject.Name
	'Register-ProviderFeature.Context.Failed'								   = 'Failed to switch content to subscription {0}' # $ScopeObject.SubscriptionDisplayName
	'Register-ProviderFeature.Provider.Feature'							       = 'Registering Feature {0} in Provider {1} namespace' # $ProviderFeature.FeatureName, $ProviderFeature.ProviderName
	
	'Register-ResourceProvider.Processing'									   = 'Processing resource provider {0} from {1}' # $ScopeObject, $FileName
	'Register-ResourceProvider.Context.Switching'							   = 'Switching Subscription context from {0}/{1} to {2}/{3}' # $currentContext.Subscription.Name, $CurrentAzContext.Subscription.Id, $ScopeObject.Subscription, $ScopeObject.Name
	'Register-ResourceProvider.Context.Failed'								   = 'Failed to switch content to subscription {0}' # $ScopeObject.SubscriptionDisplayName
	'Register-ResourceProvider.Provider.Register'							   = 'Registering provider {0}' # $resourceprovider.ProviderNamespace
	
	'Save-ManagementGroupChildren.Starting'								       = 'Starting execution' #
	'Save-ManagementGroupChildren.Processing'								   = 'Processing Scope: {0}' # $scopeObject.scope
	'Save-ManagementGroupChildren.New.File'								       = 'Creating new state file: {0}' # $statepathFileName
	'Save-ManagementGroupChildren.Moving.Source'							   = 'Found existing state file in directory: {0}' # $exisitingScopePath
	'Save-ManagementGroupChildren.Moving.Destination'						   = 'Moved existing state file to: {0}' # $statepathScopeDirectoryParent
	'Save-ManagementGroupChildren.Creating.Scope'							   = 'Creating scope object' # 
	'Save-ManagementGroupChildren.Data.Directory'							   = 'Resolved state path directory: {0}' # $statepathDirectory
	'Save-ManagementGroupChildren.Data.FileName'							   = 'Resolved state path filename: {0}' # $statepathFileName
	'Save-ManagementGroupChildren.Data.ScopeDirectory'						   = 'Resolved state path scope directory: {0}' # $statepathScopeDirectory
	'Save-ManagementGroupChildren.Data.ScopeDirectoryParent'				   = 'Resolved state path scope directory parent: {0}' # $statepathScopeDirectoryParent
	'Save-ManagementGroupChildren.Data.StatePath'							   = 'Resolved state path: {0}' # $scopeStatepath
	
	'Set-AzOpsContext.Change'												   = 'Changing active subscription from {0} to {1} ({2})' # $context.Subscription.Name, $ScopeObject.SubscriptionDisplayName, $ScopeObject.Subscription
	
	'AzOpsScope.Input.BadData.ResourceGroup'								   = 'Invalid Resource Group Data! Validate integrity of {0}' # ($children.FullName -join ', ')
	'AzOpsScope.Input.BadData.Subscription'								       = 'Invalid Subscription Data! Validate integrity of {0}' # ($children.FullName -join ', ')
	'AzOpsScope.Input.BadData.UnknownType'									   = 'Invalid File Structure! Cannot find Management Group / Subscription / Resource Group files in {0}!' # $Path
	'AzOpsScope.Input.BadData.ManagementGroup'								   = '{0} does not contain .parameters.input.value.Id'
	'AzOpsScope.GetManagementGroupName.Found.Azure'						       = 'Management Group found in Azure: {0}'
	'AzOpsScope.GetManagementGroupName.NotFound'							   = 'Management Group not found in Azure. Using directory name instead: {0}'
	'AzOpsScope.GetSubscription.Found'										   = 'SubscriptionId found in Azure: {0}'
	'AzOpsScope.GetSubscription.NotFound'									   = 'SubscriptionId not found in Azure. Using directory name instead: {0}'
	'AzOpsScope.GetSubscriptionDisplayName.Found'							   = 'Subscription DisplayName found in Azure: {0}'
	'AzOpsScope.GetSubscriptionDisplayName.NotFound'						   = 'Subscription DisplayName not found in Azure. Using directory name instead: {0}'
	'AzOpsScope.GetAzOpsResourcePath.Retrieving'							   = 'Getting Resource path for: {0}'
	'AzOpsScope.GetAzOpsResourcePath.NotFound'								   = 'Unable to determine Resource Scope for: {0}'
	'AzOpsScope.GetAzOpsManagementGroupPath.NotFound'						   = 'Management Group not found: {0}' # $managementgroupName
}