#' Metadata Data Type Validator
#'
#' A function to create a variety of objects that are part of the Metadata API service
#' Below is a list of objects and their required components to be created with this function:
#'
#' \strong{AccessMapping}
#'
#' \describe{
#'  \item{accessLevel}{a character}
#'  \item{object}{a character}
#'  \item{objectField}{a character}
#'  \item{userField}{a character}
#' }
#'
#' \strong{AccountSettings}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{enableAccountOwnerReport}{a character either 'true' or 'false'}
#'  \item{enableAccountTeams}{a character either 'true' or 'false'}
#'  \item{showViewHierarchyLink}{a character either 'true' or 'false'}
#' }
#'
#' \strong{AccountSharingRuleSettings}
#'
#' \describe{
#'  \item{caseAccessLevel}{a character}
#'  \item{contactAccessLevel}{a character}
#'  \item{opportunityAccessLevel}{a character}
#' }
#'
#' \strong{ActionLinkGroupTemplate}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{actionLinkTemplates}{a ActionLinkTemplate}
#'  \item{category}{a PlatformActionGroupCategory - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Primary}
#'      \item{Overflow}
#'    }
#'   }
#'  \item{executionsAllowed}{a ActionLinkExecutionsAllowed - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Once}
#'      \item{OncePerUser}
#'      \item{Unlimited}
#'    }
#'   }
#'  \item{hoursUntilExpiration}{an integer}
#'  \item{isPublished}{a character either 'true' or 'false'}
#'  \item{name}{a character}
#' }
#'
#' \strong{ActionLinkTemplate}
#'
#' \describe{
#'  \item{actionUrl}{a character}
#'  \item{headers}{a character}
#'  \item{isConfirmationRequired}{a character either 'true' or 'false'}
#'  \item{isGroupDefault}{a character either 'true' or 'false'}
#'  \item{label}{a character}
#'  \item{labelKey}{a character}
#'  \item{linkType}{a ActionLinkType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{API}
#'      \item{APIAsync}
#'      \item{Download}
#'      \item{UI}
#'    }
#'   }
#'  \item{method}{a ActionLinkHttpMethod - which is a character taking one of the following values:
#'    \itemize{
#'      \item{HttpDelete}
#'      \item{HttpHead}
#'      \item{HttpGet}
#'      \item{HttpPatch}
#'      \item{HttpPost}
#'      \item{HttpPut}
#'    }
#'   }
#'  \item{position}{an integer}
#'  \item{requestBody}{a character}
#'  \item{userAlias}{a character}
#'  \item{userVisibility}{a ActionLinkUserVisibility - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Creator}
#'      \item{Everyone}
#'      \item{EveryoneButCreator}
#'      \item{Manager}
#'      \item{CustomUser}
#'      \item{CustomExcludedUser}
#'    }
#'   }
#' }
#'
#' \strong{ActionOverride}
#'
#' \describe{
#'  \item{actionName}{a character}
#'  \item{comment}{a character}
#'  \item{content}{a character}
#'  \item{formFactor}{a FormFactor - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Small}
#'      \item{Medium}
#'      \item{Large}
#'    }
#'   }
#'  \item{skipRecordTypeSelect}{a character either 'true' or 'false'}
#'  \item{type}{a ActionOverrideType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Default}
#'      \item{Standard}
#'      \item{Scontrol}
#'      \item{Visualforce}
#'      \item{Flexipage}
#'      \item{LightningComponent}
#'    }
#'   }
#' }
#'
#' \strong{ActivitiesSettings}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{allowUsersToRelateMultipleContactsToTasksAndEvents}{a character either 'true' or 'false'}
#'  \item{autoRelateEventAttendees}{a character either 'true' or 'false'}
#'  \item{enableActivityReminders}{a character either 'true' or 'false'}
#'  \item{enableClickCreateEvents}{a character either 'true' or 'false'}
#'  \item{enableDragAndDropScheduling}{a character either 'true' or 'false'}
#'  \item{enableEmailTracking}{a character either 'true' or 'false'}
#'  \item{enableGroupTasks}{a character either 'true' or 'false'}
#'  \item{enableListViewScheduling}{a character either 'true' or 'false'}
#'  \item{enableLogNote}{a character either 'true' or 'false'}
#'  \item{enableMultidayEvents}{a character either 'true' or 'false'}
#'  \item{enableRecurringEvents}{a character either 'true' or 'false'}
#'  \item{enableRecurringTasks}{a character either 'true' or 'false'}
#'  \item{enableSidebarCalendarShortcut}{a character either 'true' or 'false'}
#'  \item{enableSimpleTaskCreateUI}{a character either 'true' or 'false'}
#'  \item{enableUNSTaskDelegatedToNotifications}{a character either 'true' or 'false'}
#'  \item{meetingRequestsLogo}{a character}
#'  \item{showCustomLogoMeetingRequests}{a character either 'true' or 'false'}
#'  \item{showEventDetailsMultiUserCalendar}{a character either 'true' or 'false'}
#'  \item{showHomePageHoverLinksForEvents}{a character either 'true' or 'false'}
#'  \item{showMyTasksHoverLinks}{a character either 'true' or 'false'}
#' }
#'
#' \strong{AddressSettings}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{countriesAndStates}{a CountriesAndStates}
#' }
#'
#' \strong{AdjustmentsSettings}
#'
#' \describe{
#'  \item{enableAdjustments}{a character either 'true' or 'false'}
#'  \item{enableOwnerAdjustments}{a character either 'true' or 'false'}
#' }
#'
#' \strong{AgentConfigAssignments}
#'
#' \describe{
#'  \item{profiles}{a AgentConfigProfileAssignments}
#'  \item{users}{a AgentConfigUserAssignments}
#' }
#'
#' \strong{AgentConfigButtons}
#'
#' \describe{
#'  \item{button}{a character}
#' }
#'
#' \strong{AgentConfigProfileAssignments}
#'
#' \describe{
#'  \item{profile}{a character}
#' }
#'
#' \strong{AgentConfigSkills}
#'
#' \describe{
#'  \item{skill}{a character}
#' }
#'
#' \strong{AgentConfigUserAssignments}
#'
#' \describe{
#'  \item{user}{a character}
#' }
#'
#' \strong{AnalyticsCloudComponentLayoutItem}
#'
#' \describe{
#'  \item{assetType}{a character}
#'  \item{devName}{a character}
#'  \item{error}{a character}
#'  \item{filter}{a character}
#'  \item{height}{an integer}
#'  \item{hideOnError}{a character either 'true' or 'false'}
#'  \item{showHeader}{a character either 'true' or 'false'}
#'  \item{showSharing}{a character either 'true' or 'false'}
#'  \item{showTitle}{a character either 'true' or 'false'}
#'  \item{width}{a character}
#' }
#'
#' \strong{AnalyticSnapshot}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{description}{a character}
#'  \item{groupColumn}{a character}
#'  \item{mappings}{a AnalyticSnapshotMapping}
#'  \item{name}{a character}
#'  \item{runningUser}{a character}
#'  \item{sourceReport}{a character}
#'  \item{targetObject}{a character}
#' }
#'
#' \strong{AnalyticSnapshotMapping}
#'
#' \describe{
#'  \item{aggregateType}{a ReportSummaryType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Sum}
#'      \item{Average}
#'      \item{Maximum}
#'      \item{Minimum}
#'      \item{None}
#'    }
#'   }
#'  \item{sourceField}{a character}
#'  \item{sourceType}{a ReportJobSourceTypes - which is a character taking one of the following values:
#'    \itemize{
#'      \item{tabular}
#'      \item{summary}
#'      \item{snapshot}
#'    }
#'   }
#'  \item{targetField}{a character}
#' }
#'
#' \strong{ApexClass}
#'
#' \describe{
#'  \item{content}{a character formed using \code{\link[base64enc]{base64encode}} (inherited from MetadataWithContent)}
#'  \item{apiVersion}{a numeric}
#'  \item{packageVersions}{a PackageVersion}
#'  \item{status}{a ApexCodeUnitStatus - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Inactive}
#'      \item{Active}
#'      \item{Deleted}
#'    }
#'   }
#' }
#'
#' \strong{ApexComponent}
#'
#' \describe{
#'  \item{content}{a character formed using \code{\link[base64enc]{base64encode}} (inherited from MetadataWithContent)}
#'  \item{apiVersion}{a numeric}
#'  \item{description}{a character}
#'  \item{label}{a character}
#'  \item{packageVersions}{a PackageVersion}
#' }
#'
#' \strong{ApexPage}
#'
#' \describe{
#'  \item{content}{a character formed using \code{\link[base64enc]{base64encode}} (inherited from MetadataWithContent)}
#'  \item{apiVersion}{a numeric}
#'  \item{availableInTouch}{a character either 'true' or 'false'}
#'  \item{confirmationTokenRequired}{a character either 'true' or 'false'}
#'  \item{description}{a character}
#'  \item{label}{a character}
#'  \item{packageVersions}{a PackageVersion}
#' }
#'
#' \strong{ApexTestSuite}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{testClassName}{a character}
#' }
#'
#' \strong{ApexTrigger}
#'
#' \describe{
#'  \item{content}{a character formed using \code{\link[base64enc]{base64encode}} (inherited from MetadataWithContent)}
#'  \item{apiVersion}{a numeric}
#'  \item{packageVersions}{a PackageVersion}
#'  \item{status}{a ApexCodeUnitStatus - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Inactive}
#'      \item{Active}
#'      \item{Deleted}
#'    }
#'   }
#' }
#'
#' \strong{AppActionOverride}
#'
#' \describe{
#'  \item{actionName}{a character (inherited from ActionOverride)}
#'  \item{comment}{a character (inherited from ActionOverride)}
#'  \item{content}{a character (inherited from ActionOverride)}
#'  \item{formFactor}{a FormFactor (inherited from ActionOverride)}
#'  \item{skipRecordTypeSelect}{a character either 'true' or 'false' (inherited from ActionOverride)}
#'  \item{type}{a ActionOverrideType (inherited from ActionOverride)}
#'  \item{pageOrSobjectType}{a character}
#' }
#'
#' \strong{AppBrand}
#'
#' \describe{
#'  \item{footerColor}{a character}
#'  \item{headerColor}{a character}
#'  \item{logo}{a character}
#'  \item{logoVersion}{an integer}
#'  \item{shouldOverrideOrgTheme}{a character either 'true' or 'false'}
#' }
#'
#' \strong{AppComponentList}
#'
#' \describe{
#'  \item{alignment}{a character}
#'  \item{components}{a character}
#' }
#'
#' \strong{AppMenu}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{appMenuItems}{a AppMenuItem}
#' }
#'
#' \strong{AppMenuItem}
#'
#' \describe{
#'  \item{name}{a character}
#'  \item{type}{a character}
#' }
#'
#' \strong{AppPreferences}
#'
#' \describe{
#'  \item{enableCustomizeMyTabs}{a character either 'true' or 'false'}
#'  \item{enableKeyboardShortcuts}{a character either 'true' or 'false'}
#'  \item{enableListViewHover}{a character either 'true' or 'false'}
#'  \item{enableListViewReskin}{a character either 'true' or 'false'}
#'  \item{enableMultiMonitorComponents}{a character either 'true' or 'false'}
#'  \item{enablePinTabs}{a character either 'true' or 'false'}
#'  \item{enableTabHover}{a character either 'true' or 'false'}
#'  \item{enableTabLimits}{a character either 'true' or 'false'}
#'  \item{saveUserSessions}{a character either 'true' or 'false'}
#' }
#'
#' \strong{AppProfileActionOverride}
#'
#' \describe{
#'  \item{actionName}{a character (inherited from ProfileActionOverride)}
#'  \item{content}{a character (inherited from ProfileActionOverride)}
#'  \item{formFactor}{a FormFactor (inherited from ProfileActionOverride)}
#'  \item{pageOrSobjectType}{a character (inherited from ProfileActionOverride)}
#'  \item{recordType}{a character (inherited from ProfileActionOverride)}
#'  \item{type}{a ActionOverrideType (inherited from ProfileActionOverride)}
#'  \item{profile}{a character}
#' }
#'
#' \strong{ApprovalAction}
#'
#' \describe{
#'  \item{action}{a WorkflowActionReference}
#' }
#'
#' \strong{ApprovalEntryCriteria}
#'
#' \describe{
#'  \item{booleanFilter}{a character}
#'  \item{criteriaItems}{a FilterItem}
#'  \item{formula}{a character}
#' }
#'
#' \strong{ApprovalPageField}
#'
#' \describe{
#'  \item{field}{a character}
#' }
#'
#' \strong{ApprovalProcess}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{active}{a character either 'true' or 'false'}
#'  \item{allowRecall}{a character either 'true' or 'false'}
#'  \item{allowedSubmitters}{a ApprovalSubmitter}
#'  \item{approvalPageFields}{a ApprovalPageField}
#'  \item{approvalStep}{a ApprovalStep}
#'  \item{description}{a character}
#'  \item{emailTemplate}{a character}
#'  \item{enableMobileDeviceAccess}{a character either 'true' or 'false'}
#'  \item{entryCriteria}{a ApprovalEntryCriteria}
#'  \item{finalApprovalActions}{a ApprovalAction}
#'  \item{finalApprovalRecordLock}{a character either 'true' or 'false'}
#'  \item{finalRejectionActions}{a ApprovalAction}
#'  \item{finalRejectionRecordLock}{a character either 'true' or 'false'}
#'  \item{initialSubmissionActions}{a ApprovalAction}
#'  \item{label}{a character}
#'  \item{nextAutomatedApprover}{a NextAutomatedApprover}
#'  \item{postTemplate}{a character}
#'  \item{recallActions}{a ApprovalAction}
#'  \item{recordEditability}{a RecordEditabilityType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{AdminOnly}
#'      \item{AdminOrCurrentApprover}
#'    }
#'   }
#'  \item{showApprovalHistory}{a character either 'true' or 'false'}
#' }
#'
#' \strong{ApprovalStep}
#'
#' \describe{
#'  \item{allowDelegate}{a character either 'true' or 'false'}
#'  \item{approvalActions}{a ApprovalAction}
#'  \item{assignedApprover}{a ApprovalStepApprover}
#'  \item{description}{a character}
#'  \item{entryCriteria}{a ApprovalEntryCriteria}
#'  \item{ifCriteriaNotMet}{a StepCriteriaNotMetType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{ApproveRecord}
#'      \item{RejectRecord}
#'      \item{GotoNextStep}
#'    }
#'   }
#'  \item{label}{a character}
#'  \item{name}{a character}
#'  \item{rejectBehavior}{a ApprovalStepRejectBehavior}
#'  \item{rejectionActions}{a ApprovalAction}
#' }
#'
#' \strong{ApprovalStepApprover}
#'
#' \describe{
#'  \item{approver}{a Approver}
#'  \item{whenMultipleApprovers}{a RoutingType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Unanimous}
#'      \item{FirstResponse}
#'    }
#'   }
#' }
#'
#' \strong{ApprovalStepRejectBehavior}
#'
#' \describe{
#'  \item{type}{a StepRejectBehaviorType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{RejectRequest}
#'      \item{BackToPrevious}
#'    }
#'   }
#' }
#'
#' \strong{ApprovalSubmitter}
#'
#' \describe{
#'  \item{submitter}{a character}
#'  \item{type}{a ProcessSubmitterType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{group}
#'      \item{role}
#'      \item{user}
#'      \item{roleSubordinates}
#'      \item{roleSubordinatesInternal}
#'      \item{owner}
#'      \item{creator}
#'      \item{partnerUser}
#'      \item{customerPortalUser}
#'      \item{portalRole}
#'      \item{portalRoleSubordinates}
#'      \item{allInternalUsers}
#'    }
#'   }
#' }
#'
#' \strong{Approver}
#'
#' \describe{
#'  \item{name}{a character}
#'  \item{type}{a NextOwnerType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{adhoc}
#'      \item{user}
#'      \item{userHierarchyField}
#'      \item{relatedUserField}
#'      \item{queue}
#'    }
#'   }
#' }
#'
#' \strong{AppWorkspaceConfig}
#'
#' \describe{
#'  \item{mappings}{a WorkspaceMapping}
#' }
#'
#' \strong{ArticleTypeChannelDisplay}
#'
#' \describe{
#'  \item{articleTypeTemplates}{a ArticleTypeTemplate}
#' }
#'
#' \strong{ArticleTypeTemplate}
#'
#' \describe{
#'  \item{channel}{a Channel - which is a character taking one of the following values:
#'    \itemize{
#'      \item{AllChannels}
#'      \item{App}
#'      \item{Pkb}
#'      \item{Csp}
#'      \item{Prm}
#'    }
#'   }
#'  \item{page}{a character}
#'  \item{template}{a Template - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Page}
#'      \item{Tab}
#'      \item{Toc}
#'    }
#'   }
#' }
#'
#' \strong{AssignmentRule}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{active}{a character either 'true' or 'false'}
#'  \item{ruleEntry}{a RuleEntry}
#' }
#'
#' \strong{AssignmentRules}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{assignmentRule}{a AssignmentRule}
#' }
#'
#' \strong{AssistantRecommendationType}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{description}{a character}
#'  \item{masterLabel}{a character}
#'  \item{platformActionlist}{a PlatformActionList}
#'  \item{sobjectType}{a character}
#'  \item{title}{a character}
#' }
#'
#' \strong{Attachment}
#'
#' \describe{
#'  \item{content}{a character formed using \code{\link[base64enc]{base64encode}}}
#'  \item{name}{a character}
#' }
#'
#' \strong{AuraDefinitionBundle}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{SVGContent}{a character formed using \code{\link[base64enc]{base64encode}}}
#'  \item{apiVersion}{a numeric}
#'  \item{controllerContent}{a character formed using \code{\link[base64enc]{base64encode}}}
#'  \item{description}{a character}
#'  \item{designContent}{a character formed using \code{\link[base64enc]{base64encode}}}
#'  \item{documentationContent}{a character formed using \code{\link[base64enc]{base64encode}}}
#'  \item{helperContent}{a character formed using \code{\link[base64enc]{base64encode}}}
#'  \item{markup}{a character formed using \code{\link[base64enc]{base64encode}}}
#'  \item{modelContent}{a character formed using \code{\link[base64enc]{base64encode}}}
#'  \item{packageVersions}{a PackageVersion}
#'  \item{rendererContent}{a character formed using \code{\link[base64enc]{base64encode}}}
#'  \item{styleContent}{a character formed using \code{\link[base64enc]{base64encode}}}
#'  \item{testsuiteContent}{a character formed using \code{\link[base64enc]{base64encode}}}
#'  \item{type}{a AuraBundleType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Application}
#'      \item{Component}
#'      \item{Event}
#'      \item{Interface}
#'      \item{Tokens}
#'    }
#'   }
#' }
#'
#' \strong{AuthProvider}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{authorizeUrl}{a character}
#'  \item{consumerKey}{a character}
#'  \item{consumerSecret}{a character}
#'  \item{customMetadataTypeRecord}{a character}
#'  \item{defaultScopes}{a character}
#'  \item{errorUrl}{a character}
#'  \item{executionUser}{a character}
#'  \item{friendlyName}{a character}
#'  \item{iconUrl}{a character}
#'  \item{idTokenIssuer}{a character}
#'  \item{includeOrgIdInIdentifier}{a character either 'true' or 'false'}
#'  \item{logoutUrl}{a character}
#'  \item{plugin}{a character}
#'  \item{portal}{a character}
#'  \item{providerType}{a AuthProviderType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Facebook}
#'      \item{Janrain}
#'      \item{Salesforce}
#'      \item{OpenIdConnect}
#'      \item{MicrosoftACS}
#'      \item{LinkedIn}
#'      \item{Twitter}
#'      \item{Google}
#'      \item{GitHub}
#'      \item{Custom}
#'    }
#'   }
#'  \item{registrationHandler}{a character}
#'  \item{sendAccessTokenInHeader}{a character either 'true' or 'false'}
#'  \item{sendClientCredentialsInHeader}{a character either 'true' or 'false'}
#'  \item{tokenUrl}{a character}
#'  \item{userInfoUrl}{a character}
#' }
#'
#' \strong{AutoResponseRule}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{active}{a character either 'true' or 'false'}
#'  \item{ruleEntry}{a RuleEntry}
#' }
#'
#' \strong{AutoResponseRules}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{autoResponseRule}{a AutoResponseRule}
#' }
#'
#' \strong{BrandingSet}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{brandingSetProperty}{a BrandingSetProperty}
#'  \item{description}{a character}
#'  \item{masterLabel}{a character}
#'  \item{type}{a character}
#' }
#'
#' \strong{BrandingSetProperty}
#'
#' \describe{
#'  \item{propertyName}{a character}
#'  \item{propertyValue}{a character}
#' }
#'
#' \strong{BusinessHoursEntry}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{active}{a character either 'true' or 'false'}
#'  \item{default}{a character either 'true' or 'false'}
#'  \item{fridayEndTime}{a character formatted as 'hh:mm:ssZ}
#'  \item{fridayStartTime}{a character formatted as 'hh:mm:ssZ}
#'  \item{mondayEndTime}{a character formatted as 'hh:mm:ssZ}
#'  \item{mondayStartTime}{a character formatted as 'hh:mm:ssZ}
#'  \item{name}{a character}
#'  \item{saturdayEndTime}{a character formatted as 'hh:mm:ssZ}
#'  \item{saturdayStartTime}{a character formatted as 'hh:mm:ssZ}
#'  \item{sundayEndTime}{a character formatted as 'hh:mm:ssZ}
#'  \item{sundayStartTime}{a character formatted as 'hh:mm:ssZ}
#'  \item{thursdayEndTime}{a character formatted as 'hh:mm:ssZ}
#'  \item{thursdayStartTime}{a character formatted as 'hh:mm:ssZ}
#'  \item{timeZoneId}{a character}
#'  \item{tuesdayEndTime}{a character formatted as 'hh:mm:ssZ}
#'  \item{tuesdayStartTime}{a character formatted as 'hh:mm:ssZ}
#'  \item{wednesdayEndTime}{a character formatted as 'hh:mm:ssZ}
#'  \item{wednesdayStartTime}{a character formatted as 'hh:mm:ssZ}
#' }
#'
#' \strong{BusinessHoursSettings}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{businessHours}{a BusinessHoursEntry}
#'  \item{holidays}{a Holiday}
#' }
#'
#' \strong{BusinessProcess}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{description}{a character}
#'  \item{isActive}{a character either 'true' or 'false'}
#'  \item{values}{a PicklistValue}
#' }
#'
#' \strong{CallCenter}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{adapterUrl}{a character}
#'  \item{customSettings}{a character}
#'  \item{displayName}{a character}
#'  \item{displayNameLabel}{a character}
#'  \item{internalNameLabel}{a character}
#'  \item{sections}{a CallCenterSection}
#'  \item{version}{a character}
#' }
#'
#' \strong{CallCenterItem}
#'
#' \describe{
#'  \item{label}{a character}
#'  \item{name}{a character}
#'  \item{value}{a character}
#' }
#'
#' \strong{CallCenterSection}
#'
#' \describe{
#'  \item{items}{a CallCenterItem}
#'  \item{label}{a character}
#'  \item{name}{a character}
#' }
#'
#' \strong{CampaignInfluenceModel}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{isActive}{a character either 'true' or 'false'}
#'  \item{isDefaultModel}{a character either 'true' or 'false'}
#'  \item{isModelLocked}{a character either 'true' or 'false'}
#'  \item{modelDescription}{a character}
#'  \item{name}{a character}
#'  \item{recordPreference}{a character}
#' }
#'
#' \strong{CaseSettings}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{caseAssignNotificationTemplate}{a character}
#'  \item{caseCloseNotificationTemplate}{a character}
#'  \item{caseCommentNotificationTemplate}{a character}
#'  \item{caseCreateNotificationTemplate}{a character}
#'  \item{caseFeedItemSettings}{a FeedItemSettings}
#'  \item{closeCaseThroughStatusChange}{a character either 'true' or 'false'}
#'  \item{defaultCaseOwner}{a character}
#'  \item{defaultCaseOwnerType}{a character}
#'  \item{defaultCaseUser}{a character}
#'  \item{emailActionDefaultsHandlerClass}{a character}
#'  \item{emailToCase}{a EmailToCaseSettings}
#'  \item{enableCaseFeed}{a character either 'true' or 'false'}
#'  \item{enableDraftEmails}{a character either 'true' or 'false'}
#'  \item{enableEarlyEscalationRuleTriggers}{a character either 'true' or 'false'}
#'  \item{enableEmailActionDefaultsHandler}{a character either 'true' or 'false'}
#'  \item{enableSuggestedArticlesApplication}{a character either 'true' or 'false'}
#'  \item{enableSuggestedArticlesCustomerPortal}{a character either 'true' or 'false'}
#'  \item{enableSuggestedArticlesPartnerPortal}{a character either 'true' or 'false'}
#'  \item{enableSuggestedSolutions}{a character either 'true' or 'false'}
#'  \item{keepRecordTypeOnAssignmentRule}{a character either 'true' or 'false'}
#'  \item{notifyContactOnCaseComment}{a character either 'true' or 'false'}
#'  \item{notifyDefaultCaseOwner}{a character either 'true' or 'false'}
#'  \item{notifyOwnerOnCaseComment}{a character either 'true' or 'false'}
#'  \item{notifyOwnerOnCaseOwnerChange}{a character either 'true' or 'false'}
#'  \item{showEmailAttachmentsInCaseAttachmentsRL}{a character either 'true' or 'false'}
#'  \item{showFewerCloseActions}{a character either 'true' or 'false'}
#'  \item{systemUserEmail}{a character}
#'  \item{useSystemEmailAddress}{a character either 'true' or 'false'}
#'  \item{useSystemUserAsDefaultCaseUser}{a character either 'true' or 'false'}
#'  \item{webToCase}{a WebToCaseSettings}
#' }
#'
#' \strong{CaseSubjectParticle}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{index}{an integer}
#'  \item{textField}{a character}
#'  \item{type}{a CaseSubjectParticleType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{ProvidedString}
#'      \item{Source}
#'      \item{MessageType}
#'      \item{SocialHandle}
#'      \item{SocialNetwork}
#'      \item{Sentiment}
#'      \item{RealName}
#'      \item{Content}
#'      \item{PipeSeparator}
#'      \item{ColonSeparator}
#'      \item{HyphenSeparator}
#'    }
#'   }
#' }
#'
#' \strong{Certificate}
#'
#' \describe{
#'  \item{content}{a character formed using \code{\link[base64enc]{base64encode}} (inherited from MetadataWithContent)}
#'  \item{caSigned}{a character either 'true' or 'false'}
#'  \item{encryptedWithPlatformEncryption}{a character either 'true' or 'false'}
#'  \item{expirationDate}{a character formatted as 'yyyy-mm-ddThh:mm:ssZ'}
#'  \item{keySize}{an integer}
#'  \item{masterLabel}{a character}
#'  \item{privateKeyExportable}{a character either 'true' or 'false'}
#' }
#'
#' \strong{ChannelLayout}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{enabledChannels}{a character}
#'  \item{label}{a character}
#'  \item{layoutItems}{a ChannelLayoutItem}
#'  \item{recordType}{a character}
#' }
#'
#' \strong{ChannelLayoutItem}
#'
#' \describe{
#'  \item{field}{a character}
#' }
#'
#' \strong{ChartSummary}
#'
#' \describe{
#'  \item{aggregate}{a ReportSummaryType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Sum}
#'      \item{Average}
#'      \item{Maximum}
#'      \item{Minimum}
#'      \item{None}
#'    }
#'   }
#'  \item{axisBinding}{a ChartAxis - which is a character taking one of the following values:
#'    \itemize{
#'      \item{x}
#'      \item{y}
#'      \item{y2}
#'      \item{r}
#'    }
#'   }
#'  \item{column}{a character}
#' }
#'
#' \strong{ChatterAnswersReputationLevel}
#'
#' \describe{
#'  \item{name}{a character}
#'  \item{value}{an integer}
#' }
#'
#' \strong{ChatterAnswersSettings}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{emailFollowersOnBestAnswer}{a character either 'true' or 'false'}
#'  \item{emailFollowersOnReply}{a character either 'true' or 'false'}
#'  \item{emailOwnerOnPrivateReply}{a character either 'true' or 'false'}
#'  \item{emailOwnerOnReply}{a character either 'true' or 'false'}
#'  \item{enableAnswerViaEmail}{a character either 'true' or 'false'}
#'  \item{enableChatterAnswers}{a character either 'true' or 'false'}
#'  \item{enableFacebookSSO}{a character either 'true' or 'false'}
#'  \item{enableInlinePublisher}{a character either 'true' or 'false'}
#'  \item{enableReputation}{a character either 'true' or 'false'}
#'  \item{enableRichTextEditor}{a character either 'true' or 'false'}
#'  \item{facebookAuthProvider}{a character}
#'  \item{showInPortals}{a character either 'true' or 'false'}
#' }
#'
#' \strong{ChatterExtension}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{compositionComponent}{a character}
#'  \item{description}{a character}
#'  \item{extensionName}{a character}
#'  \item{headerText}{a character}
#'  \item{hoverText}{a character}
#'  \item{icon}{a character}
#'  \item{isProtected}{a character either 'true' or 'false'}
#'  \item{masterLabel}{a character}
#'  \item{renderComponent}{a character}
#'  \item{type}{a ChatterExtensionType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Lightning}
#'    }
#'   }
#' }
#'
#' \strong{ChatterMobileSettings}
#'
#' \describe{
#'  \item{enablePushNotifications}{a character either 'true' or 'false'}
#' }
#'
#' \strong{CleanDataService}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{cleanRules}{a CleanRule}
#'  \item{description}{a character}
#'  \item{masterLabel}{a character}
#'  \item{matchEngine}{a character}
#' }
#'
#' \strong{CleanRule}
#'
#' \describe{
#'  \item{bulkEnabled}{a character either 'true' or 'false'}
#'  \item{bypassTriggers}{a character either 'true' or 'false'}
#'  \item{bypassWorkflow}{a character either 'true' or 'false'}
#'  \item{description}{a character}
#'  \item{developerName}{a character}
#'  \item{fieldMappings}{a FieldMapping}
#'  \item{masterLabel}{a character}
#'  \item{matchRule}{a character}
#'  \item{sourceSobjectType}{a character}
#'  \item{status}{a CleanRuleStatus - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Inactive}
#'      \item{Active}
#'    }
#'   }
#'  \item{targetSobjectType}{a character}
#' }
#'
#' \strong{CodeLocation}
#'
#' \describe{
#'  \item{column}{an integer}
#'  \item{line}{an integer}
#'  \item{numExecutions}{an integer}
#'  \item{time}{a numeric}
#' }
#'
#' \strong{Community}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{active}{a character either 'true' or 'false'}
#'  \item{chatterAnswersFacebookSsoUrl}{a character}
#'  \item{communityFeedPage}{a character}
#'  \item{dataCategoryName}{a character}
#'  \item{description}{a character}
#'  \item{emailFooterDocument}{a character}
#'  \item{emailHeaderDocument}{a character}
#'  \item{emailNotificationUrl}{a character}
#'  \item{enableChatterAnswers}{a character either 'true' or 'false'}
#'  \item{enablePrivateQuestions}{a character either 'true' or 'false'}
#'  \item{expertsGroup}{a character}
#'  \item{portal}{a character}
#'  \item{reputationLevels}{a ReputationLevels}
#'  \item{showInPortal}{a character either 'true' or 'false'}
#'  \item{site}{a character}
#' }
#'
#' \strong{CommunityCustomThemeLayoutType}
#'
#' \describe{
#'  \item{description}{a character}
#'  \item{label}{a character}
#' }
#'
#' \strong{CommunityRoles}
#'
#' \describe{
#'  \item{customerUserRole}{a character}
#'  \item{employeeUserRole}{a character}
#'  \item{partnerUserRole}{a character}
#' }
#'
#' \strong{CommunityTemplateBundleInfo}
#'
#' \describe{
#'  \item{description}{a character}
#'  \item{image}{a character}
#'  \item{order}{an integer}
#'  \item{title}{a character}
#'  \item{type}{a CommunityTemplateBundleInfoType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Highlight}
#'      \item{PreviewImage}
#'    }
#'   }
#' }
#'
#' \strong{CommunityTemplateDefinition}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{baseTemplate}{a CommunityBaseTemplate - which is a character taking one of the following values:
#'    \itemize{
#'      \item{c}
#'    }
#'   }
#'  \item{bundlesInfo}{a CommunityTemplateBundleInfo}
#'  \item{category}{a CommunityTemplateCategory - which is a character taking one of the following values:
#'    \itemize{
#'      \item{IT}
#'      \item{Marketing}
#'      \item{Sales}
#'      \item{Service}
#'    }
#'   }
#'  \item{defaultBrandingSet}{a character}
#'  \item{defaultThemeDefinition}{a character}
#'  \item{description}{a character}
#'  \item{enableExtendedCleanUpOnDelete}{a character either 'true' or 'false'}
#'  \item{masterLabel}{a character}
#'  \item{navigationLinkSet}{a NavigationLinkSet}
#'  \item{pageSetting}{a CommunityTemplatePageSetting}
#' }
#'
#' \strong{CommunityTemplatePageSetting}
#'
#' \describe{
#'  \item{page}{a character}
#'  \item{themeLayout}{a character}
#' }
#'
#' \strong{CommunityThemeDefinition}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{customThemeLayoutType}{a CommunityCustomThemeLayoutType}
#'  \item{description}{a character}
#'  \item{enableExtendedCleanUpOnDelete}{a character either 'true' or 'false'}
#'  \item{masterLabel}{a character}
#'  \item{themeSetting}{a CommunityThemeSetting}
#' }
#'
#' \strong{CommunityThemeSetting}
#'
#' \describe{
#'  \item{customThemeLayoutType}{a character}
#'  \item{themeLayout}{a character}
#'  \item{themeLayoutType}{a CommunityThemeLayoutType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Login}
#'      \item{Home}
#'      \item{Inner}
#'    }
#'   }
#' }
#'
#' \strong{CompactLayout}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{fields}{a character}
#'  \item{label}{a character}
#' }
#'
#' \strong{CompanySettings}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{fiscalYear}{a FiscalYearSettings}
#' }
#'
#' \strong{ComponentInstance}
#'
#' \describe{
#'  \item{componentInstanceProperties}{a ComponentInstanceProperty}
#'  \item{componentName}{a character}
#'  \item{visibilityRule}{a UiFormulaRule}
#' }
#'
#' \strong{ComponentInstanceProperty}
#'
#' \describe{
#'  \item{name}{a character}
#'  \item{type}{a ComponentInstancePropertyTypeEnum - which is a character taking one of the following values:
#'    \itemize{
#'      \item{decorator}
#'    }
#'   }
#'  \item{value}{a character}
#' }
#'
#' \strong{ConnectedApp}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{attributes}{a ConnectedAppAttribute}
#'  \item{canvasConfig}{a ConnectedAppCanvasConfig}
#'  \item{contactEmail}{a character}
#'  \item{contactPhone}{a character}
#'  \item{description}{a character}
#'  \item{iconUrl}{a character}
#'  \item{infoUrl}{a character}
#'  \item{ipRanges}{a ConnectedAppIpRange}
#'  \item{label}{a character}
#'  \item{logoUrl}{a character}
#'  \item{mobileAppConfig}{a ConnectedAppMobileDetailConfig}
#'  \item{mobileStartUrl}{a character}
#'  \item{oauthConfig}{a ConnectedAppOauthConfig}
#'  \item{plugin}{a character}
#'  \item{samlConfig}{a ConnectedAppSamlConfig}
#'  \item{startUrl}{a character}
#' }
#'
#' \strong{ConnectedAppAttribute}
#'
#' \describe{
#'  \item{formula}{a character}
#'  \item{key}{a character}
#' }
#'
#' \strong{ConnectedAppCanvasConfig}
#'
#' \describe{
#'  \item{accessMethod}{a AccessMethod - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Get}
#'      \item{Post}
#'    }
#'   }
#'  \item{canvasUrl}{a character}
#'  \item{lifecycleClass}{a character}
#'  \item{locations}{a CanvasLocationOptions - which is a character taking one of the following values:
#'    \itemize{
#'      \item{None}
#'      \item{Chatter}
#'      \item{UserProfile}
#'      \item{Visualforce}
#'      \item{Aura}
#'      \item{Publisher}
#'      \item{ChatterFeed}
#'      \item{ServiceDesk}
#'      \item{OpenCTI}
#'      \item{AppLauncher}
#'      \item{MobileNav}
#'      \item{PageLayout}
#'    }
#'   }
#'  \item{options}{a CanvasOptions - which is a character taking one of the following values:
#'    \itemize{
#'      \item{HideShare}
#'      \item{HideHeader}
#'      \item{PersonalEnabled}
#'    }
#'   }
#'  \item{samlInitiationMethod}{a SamlInitiationMethod - which is a character taking one of the following values:
#'    \itemize{
#'      \item{None}
#'      \item{IdpInitiated}
#'      \item{SpInitiated}
#'    }
#'   }
#' }
#'
#' \strong{ConnectedAppIpRange}
#'
#' \describe{
#'  \item{description}{a character}
#'  \item{end}{a character}
#'  \item{start}{a character}
#' }
#'
#' \strong{ConnectedAppMobileDetailConfig}
#'
#' \describe{
#'  \item{applicationBinaryFile}{a character formed using \code{\link[base64enc]{base64encode}}}
#'  \item{applicationBinaryFileName}{a character}
#'  \item{applicationBundleIdentifier}{a character}
#'  \item{applicationFileLength}{an integer}
#'  \item{applicationIconFile}{a character}
#'  \item{applicationIconFileName}{a character}
#'  \item{applicationInstallUrl}{a character}
#'  \item{devicePlatform}{a DevicePlatformType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{ios}
#'      \item{android}
#'    }
#'   }
#'  \item{deviceType}{a DeviceType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{phone}
#'      \item{tablet}
#'      \item{minitablet}
#'    }
#'   }
#'  \item{minimumOsVersion}{a character}
#'  \item{privateApp}{a character either 'true' or 'false'}
#'  \item{version}{a character}
#' }
#'
#' \strong{ConnectedAppOauthConfig}
#'
#' \describe{
#'  \item{callbackUrl}{a character}
#'  \item{certificate}{a character}
#'  \item{consumerKey}{a character}
#'  \item{consumerSecret}{a character}
#'  \item{scopes}{a ConnectedAppOauthAccessScope - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Basic}
#'      \item{Api}
#'      \item{Web}
#'      \item{Full}
#'      \item{Chatter}
#'      \item{CustomApplications}
#'      \item{RefreshToken}
#'      \item{OpenID}
#'      \item{Profile}
#'      \item{Email}
#'      \item{Address}
#'      \item{Phone}
#'      \item{OfflineAccess}
#'      \item{CustomPermissions}
#'      \item{Wave}
#'      \item{Eclair}
#'    }
#'   }
#'  \item{singleLogoutUrl}{a character}
#' }
#'
#' \strong{ConnectedAppSamlConfig}
#'
#' \describe{
#'  \item{acsUrl}{a character}
#'  \item{certificate}{a character}
#'  \item{encryptionCertificate}{a character}
#'  \item{encryptionType}{a SamlEncryptionType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{AES_128}
#'      \item{AES_256}
#'      \item{Triple_Des}
#'    }
#'   }
#'  \item{entityUrl}{a character}
#'  \item{issuer}{a character}
#'  \item{samlIdpSLOBindingEnum}{a SamlIdpSLOBinding - which is a character taking one of the following values:
#'    \itemize{
#'      \item{RedirectBinding}
#'      \item{PostBinding}
#'    }
#'   }
#'  \item{samlNameIdFormat}{a SamlNameIdFormatType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Unspecified}
#'      \item{EmailAddress}
#'      \item{Persistent}
#'      \item{Transient}
#'    }
#'   }
#'  \item{samlSloUrl}{a character}
#'  \item{samlSubjectCustomAttr}{a character}
#'  \item{samlSubjectType}{a SamlSubjectType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Username}
#'      \item{FederationId}
#'      \item{UserId}
#'      \item{SpokeId}
#'      \item{CustomAttribute}
#'      \item{PersistentId}
#'    }
#'   }
#' }
#'
#' \strong{Container}
#'
#' \describe{
#'  \item{height}{an integer}
#'  \item{isContainerAutoSizeEnabled}{a character either 'true' or 'false'}
#'  \item{region}{a character}
#'  \item{sidebarComponents}{a SidebarComponent}
#'  \item{style}{a character}
#'  \item{unit}{a character}
#'  \item{width}{an integer}
#' }
#'
#' \strong{ContentAsset}
#'
#' \describe{
#'  \item{content}{a character formed using \code{\link[base64enc]{base64encode}} (inherited from MetadataWithContent)}
#'  \item{format}{a ContentAssetFormat - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Original}
#'      \item{ZippedVersions}
#'    }
#'   }
#'  \item{language}{a character}
#'  \item{masterLabel}{a character}
#'  \item{originNetwork}{a character}
#'  \item{relationships}{a ContentAssetRelationships}
#'  \item{versions}{a ContentAssetVersions}
#' }
#'
#' \strong{ContentAssetLink}
#'
#' \describe{
#'  \item{access}{a ContentAssetAccess - which is a character taking one of the following values:
#'    \itemize{
#'      \item{VIEWER}
#'      \item{COLLABORATOR}
#'      \item{INFERRED}
#'    }
#'   }
#'  \item{isManagingWorkspace}{a character either 'true' or 'false'}
#'  \item{name}{a character}
#' }
#'
#' \strong{ContentAssetRelationships}
#'
#' \describe{
#'  \item{insightsApplication}{a ContentAssetLink}
#'  \item{network}{a ContentAssetLink}
#'  \item{organization}{a ContentAssetLink}
#'  \item{workspace}{a ContentAssetLink}
#' }
#'
#' \strong{ContentAssetVersion}
#'
#' \describe{
#'  \item{number}{a character}
#'  \item{pathOnClient}{a character}
#'  \item{zipEntry}{a character}
#' }
#'
#' \strong{ContentAssetVersions}
#'
#' \describe{
#'  \item{version}{a ContentAssetVersion}
#' }
#'
#' \strong{ContractSettings}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{autoCalculateEndDate}{a character either 'true' or 'false'}
#'  \item{autoExpirationDelay}{a character}
#'  \item{autoExpirationRecipient}{a character}
#'  \item{autoExpireContracts}{a character either 'true' or 'false'}
#'  \item{enableContractHistoryTracking}{a character either 'true' or 'false'}
#'  \item{notifyOwnersOnContractExpiration}{a character either 'true' or 'false'}
#' }
#'
#' \strong{CorsWhitelistOrigin}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{urlPattern}{a character}
#' }
#'
#' \strong{CountriesAndStates}
#'
#' \describe{
#'  \item{countries}{a Country}
#' }
#'
#' \strong{Country}
#'
#' \describe{
#'  \item{active}{a character either 'true' or 'false'}
#'  \item{integrationValue}{a character}
#'  \item{isoCode}{a character}
#'  \item{label}{a character}
#'  \item{orgDefault}{a character either 'true' or 'false'}
#'  \item{standard}{a character either 'true' or 'false'}
#'  \item{states}{a State}
#'  \item{visible}{a character either 'true' or 'false'}
#' }
#'
#' \strong{CspTrustedSite}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{description}{a character}
#'  \item{endpointUrl}{a character}
#'  \item{isActive}{a character either 'true' or 'false'}
#' }
#'
#' \strong{CustomApplication}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{actionOverrides}{a AppActionOverride}
#'  \item{brand}{a AppBrand}
#'  \item{consoleConfig}{a ServiceCloudConsoleConfig}
#'  \item{defaultLandingTab}{a character}
#'  \item{description}{a character}
#'  \item{formFactors}{a FormFactor - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Small}
#'      \item{Medium}
#'      \item{Large}
#'    }
#'   }
#'  \item{isServiceCloudConsole}{a character either 'true' or 'false'}
#'  \item{label}{a character}
#'  \item{logo}{a character}
#'  \item{navType}{a NavType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Standard}
#'      \item{Console}
#'    }
#'   }
#'  \item{preferences}{a AppPreferences}
#'  \item{profileActionOverrides}{a AppProfileActionOverride}
#'  \item{setupExperience}{a character}
#'  \item{subscriberTabs}{a character}
#'  \item{tabs}{a character}
#'  \item{uiType}{a UiType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Aloha}
#'      \item{Lightning}
#'    }
#'   }
#'  \item{utilityBar}{a character}
#'  \item{workspaceConfig}{a AppWorkspaceConfig}
#' }
#'
#' \strong{CustomApplicationComponent}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{buttonIconUrl}{a character}
#'  \item{buttonStyle}{a character}
#'  \item{buttonText}{a character}
#'  \item{buttonWidth}{an integer}
#'  \item{height}{an integer}
#'  \item{isHeightFixed}{a character either 'true' or 'false'}
#'  \item{isHidden}{a character either 'true' or 'false'}
#'  \item{isWidthFixed}{a character either 'true' or 'false'}
#'  \item{visualforcePage}{a character}
#'  \item{width}{an integer}
#' }
#'
#' \strong{CustomApplicationTranslation}
#'
#' \describe{
#'  \item{label}{a character}
#'  \item{name}{a character}
#' }
#'
#' \strong{CustomConsoleComponents}
#'
#' \describe{
#'  \item{primaryTabComponents}{a PrimaryTabComponents}
#'  \item{subtabComponents}{a SubtabComponents}
#' }
#'
#' \strong{CustomDataType}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{customDataTypeComponents}{a CustomDataTypeComponent}
#'  \item{description}{a character}
#'  \item{displayFormula}{a character}
#'  \item{editComponentsOnSeparateLines}{a character either 'true' or 'false'}
#'  \item{label}{a character}
#'  \item{rightAligned}{a character either 'true' or 'false'}
#'  \item{supportComponentsInReports}{a character either 'true' or 'false'}
#' }
#'
#' \strong{CustomDataTypeComponent}
#'
#' \describe{
#'  \item{developerSuffix}{a character}
#'  \item{enforceFieldRequiredness}{a character either 'true' or 'false'}
#'  \item{label}{a character}
#'  \item{length}{an integer}
#'  \item{precision}{an integer}
#'  \item{scale}{an integer}
#'  \item{sortOrder}{a SortOrder - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Asc}
#'      \item{Desc}
#'    }
#'   }
#'  \item{sortPriority}{an integer}
#'  \item{type}{a FieldType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{AutoNumber}
#'      \item{Lookup}
#'      \item{MasterDetail}
#'      \item{Checkbox}
#'      \item{Currency}
#'      \item{Date}
#'      \item{DateTime}
#'      \item{Email}
#'      \item{Number}
#'      \item{Percent}
#'      \item{Phone}
#'      \item{Picklist}
#'      \item{MultiselectPicklist}
#'      \item{Text}
#'      \item{TextArea}
#'      \item{LongTextArea}
#'      \item{Html}
#'      \item{Url}
#'      \item{EncryptedText}
#'      \item{Summary}
#'      \item{Hierarchy}
#'      \item{File}
#'      \item{MetadataRelationship}
#'      \item{Location}
#'      \item{ExternalLookup}
#'      \item{IndirectLookup}
#'      \item{CustomDataType}
#'      \item{Time}
#'    }
#'   }
#' }
#'
#' \strong{CustomDataTypeComponentTranslation}
#'
#' \describe{
#'  \item{developerSuffix}{a character}
#'  \item{label}{a character}
#' }
#'
#' \strong{CustomDataTypeTranslation}
#'
#' \describe{
#'  \item{components}{a CustomDataTypeComponentTranslation}
#'  \item{customDataTypeName}{a character}
#'  \item{description}{a character}
#'  \item{label}{a character}
#' }
#'
#' \strong{CustomExperience}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{allowInternalUserLogin}{a character either 'true' or 'false'}
#'  \item{branding}{a CustomExperienceBranding}
#'  \item{changePasswordEmailTemplate}{a character}
#'  \item{emailFooterLogo}{a character}
#'  \item{emailFooterText}{a character}
#'  \item{emailSenderAddress}{a character}
#'  \item{emailSenderName}{a character}
#'  \item{enableErrorPageOverridesForVisualforce}{a character either 'true' or 'false'}
#'  \item{forgotPasswordEmailTemplate}{a character}
#'  \item{picassoSite}{a character}
#'  \item{sObjectType}{a character}
#'  \item{sendWelcomeEmail}{a character either 'true' or 'false'}
#'  \item{site}{a character}
#'  \item{siteAsContainerEnabled}{a character either 'true' or 'false'}
#'  \item{tabs}{a CustomExperienceTabSet}
#'  \item{urlPathPrefix}{a character}
#'  \item{welcomeEmailTemplate}{a character}
#' }
#'
#' \strong{CustomExperienceBranding}
#'
#' \describe{
#'  \item{loginFooterText}{a character}
#'  \item{loginLogo}{a character}
#'  \item{pageFooter}{a character}
#'  \item{pageHeader}{a character}
#'  \item{primaryColor}{a character}
#'  \item{primaryComplementColor}{a character}
#'  \item{quaternaryColor}{a character}
#'  \item{quaternaryComplementColor}{a character}
#'  \item{secondaryColor}{a character}
#'  \item{tertiaryColor}{a character}
#'  \item{tertiaryComplementColor}{a character}
#'  \item{zeronaryColor}{a character}
#'  \item{zeronaryComplementColor}{a character}
#' }
#'
#' \strong{CustomExperienceTabSet}
#'
#' \describe{
#'  \item{customTab}{a character}
#'  \item{defaultTab}{a character}
#'  \item{standardTab}{a character}
#' }
#'
#' \strong{CustomFeedFilter}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{criteria}{a FeedFilterCriterion}
#'  \item{description}{a character}
#'  \item{isProtected}{a character either 'true' or 'false'}
#'  \item{label}{a character}
#' }
#'
#' \strong{CustomField}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{businessOwnerGroup}{a character}
#'  \item{businessOwnerUser}{a character}
#'  \item{businessStatus}{a character}
#'  \item{caseSensitive}{a character either 'true' or 'false'}
#'  \item{customDataType}{a character}
#'  \item{defaultValue}{a character}
#'  \item{deleteConstraint}{a DeleteConstraint - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Cascade}
#'      \item{Restrict}
#'      \item{SetNull}
#'    }
#'   }
#'  \item{deprecated}{a character either 'true' or 'false'}
#'  \item{description}{a character}
#'  \item{displayFormat}{a character}
#'  \item{encrypted}{a character either 'true' or 'false'}
#'  \item{escapeMarkup}{a character either 'true' or 'false'}
#'  \item{externalDeveloperName}{a character}
#'  \item{externalId}{a character either 'true' or 'false'}
#'  \item{fieldManageability}{a FieldManageability - which is a character taking one of the following values:
#'    \itemize{
#'      \item{DeveloperControlled}
#'      \item{SubscriberControlled}
#'      \item{Locked}
#'    }
#'   }
#'  \item{formula}{a character}
#'  \item{formulaTreatBlanksAs}{a TreatBlanksAs - which is a character taking one of the following values:
#'    \itemize{
#'      \item{BlankAsBlank}
#'      \item{BlankAsZero}
#'    }
#'   }
#'  \item{inlineHelpText}{a character}
#'  \item{isConvertLeadDisabled}{a character either 'true' or 'false'}
#'  \item{isFilteringDisabled}{a character either 'true' or 'false'}
#'  \item{isNameField}{a character either 'true' or 'false'}
#'  \item{isSortingDisabled}{a character either 'true' or 'false'}
#'  \item{label}{a character}
#'  \item{length}{an integer}
#'  \item{lookupFilter}{a LookupFilter}
#'  \item{maskChar}{a EncryptedFieldMaskChar - which is a character taking one of the following values:
#'    \itemize{
#'      \item{asterisk}
#'      \item{X}
#'    }
#'   }
#'  \item{maskType}{a EncryptedFieldMaskType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{all}
#'      \item{creditCard}
#'      \item{ssn}
#'      \item{lastFour}
#'      \item{sin}
#'      \item{nino}
#'    }
#'   }
#'  \item{metadataRelationshipControllingField}{a character}
#'  \item{populateExistingRows}{a character either 'true' or 'false'}
#'  \item{precision}{an integer}
#'  \item{referenceTargetField}{a character}
#'  \item{referenceTo}{a character}
#'  \item{relationshipLabel}{a character}
#'  \item{relationshipName}{a character}
#'  \item{relationshipOrder}{an integer}
#'  \item{reparentableMasterDetail}{a character either 'true' or 'false'}
#'  \item{required}{a character either 'true' or 'false'}
#'  \item{restrictedAdminField}{a character either 'true' or 'false'}
#'  \item{scale}{an integer}
#'  \item{securityClassification}{a SecurityClassification - which is a character taking one of the following values:
#'    \itemize{
#'      \item{AccountInformation}
#'      \item{ConfigurationAndUsageData}
#'      \item{DataIntendedToBePublic}
#'      \item{BusinessSetupDataBusinessDataAndAggregates}
#'      \item{AssociativeBusinessOrPersonalData}
#'      \item{AuthenticationData}
#'    }
#'   }
#'  \item{startingNumber}{an integer}
#'  \item{stripMarkup}{a character either 'true' or 'false'}
#'  \item{summarizedField}{a character}
#'  \item{summaryFilterItems}{a FilterItem}
#'  \item{summaryForeignKey}{a character}
#'  \item{summaryOperation}{a SummaryOperations - which is a character taking one of the following values:
#'    \itemize{
#'      \item{count}
#'      \item{sum}
#'      \item{min}
#'      \item{max}
#'    }
#'   }
#'  \item{trackFeedHistory}{a character either 'true' or 'false'}
#'  \item{trackHistory}{a character either 'true' or 'false'}
#'  \item{trackTrending}{a character either 'true' or 'false'}
#'  \item{type}{a FieldType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{AutoNumber}
#'      \item{Lookup}
#'      \item{MasterDetail}
#'      \item{Checkbox}
#'      \item{Currency}
#'      \item{Date}
#'      \item{DateTime}
#'      \item{Email}
#'      \item{Number}
#'      \item{Percent}
#'      \item{Phone}
#'      \item{Picklist}
#'      \item{MultiselectPicklist}
#'      \item{Text}
#'      \item{TextArea}
#'      \item{LongTextArea}
#'      \item{Html}
#'      \item{Url}
#'      \item{EncryptedText}
#'      \item{Summary}
#'      \item{Hierarchy}
#'      \item{File}
#'      \item{MetadataRelationship}
#'      \item{Location}
#'      \item{ExternalLookup}
#'      \item{IndirectLookup}
#'      \item{CustomDataType}
#'      \item{Time}
#'    }
#'   }
#'  \item{unique}{a character either 'true' or 'false'}
#'  \item{valueSet}{a ValueSet}
#'  \item{visibleLines}{an integer}
#'  \item{writeRequiresMasterRead}{a character either 'true' or 'false'}
#' }
#'
#' \strong{CustomFieldTranslation}
#'
#' \describe{
#'  \item{caseValues}{a ObjectNameCaseValue}
#'  \item{gender}{a Gender - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Neuter}
#'      \item{Masculine}
#'      \item{Feminine}
#'      \item{AnimateMasculine}
#'    }
#'   }
#'  \item{help}{a character}
#'  \item{label}{a character}
#'  \item{lookupFilter}{a LookupFilterTranslation}
#'  \item{name}{a character}
#'  \item{picklistValues}{a PicklistValueTranslation}
#'  \item{relationshipLabel}{a character}
#'  \item{startsWith}{a StartsWith - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Consonant}
#'      \item{Vowel}
#'      \item{Special}
#'    }
#'   }
#' }
#'
#' \strong{CustomLabel}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{categories}{a character}
#'  \item{language}{a character}
#'  \item{protected}{a character either 'true' or 'false'}
#'  \item{shortDescription}{a character}
#'  \item{value}{a character}
#' }
#'
#' \strong{CustomLabels}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{labels}{a CustomLabel}
#' }
#'
#' \strong{CustomLabelTranslation}
#'
#' \describe{
#'  \item{label}{a character}
#'  \item{name}{a character}
#' }
#'
#' \strong{CustomMetadata}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{description}{a character}
#'  \item{label}{a character}
#'  \item{protected}{a character either 'true' or 'false'}
#'  \item{values}{a CustomMetadataValue}
#' }
#'
#' \strong{CustomMetadataValue}
#'
#' \describe{
#'  \item{field}{a character}
#'  \item{value}{a character that appears similar to any of the other accepted types (integer, numeric, date, datetime, boolean)}
#' }
#'
#' \strong{CustomNotificationType}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{customNotifTypeName}{a character}
#'  \item{description}{a character}
#'  \item{desktop}{a character either 'true' or 'false'}
#'  \item{email}{a character either 'true' or 'false'}
#'  \item{masterLabel}{a character}
#'  \item{mobile}{a character either 'true' or 'false'}
#' }
#'
#' \strong{CustomObject}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{actionOverrides}{a ActionOverride}
#'  \item{allowInChatterGroups}{a character either 'true' or 'false'}
#'  \item{articleTypeChannelDisplay}{a ArticleTypeChannelDisplay}
#'  \item{businessProcesses}{a BusinessProcess}
#'  \item{compactLayoutAssignment}{a character}
#'  \item{compactLayouts}{a CompactLayout}
#'  \item{customHelp}{a character}
#'  \item{customHelpPage}{a character}
#'  \item{customSettingsType}{a CustomSettingsType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{List}
#'      \item{Hierarchy}
#'    }
#'   }
#'  \item{dataStewardGroup}{a character}
#'  \item{dataStewardUser}{a character}
#'  \item{deploymentStatus}{a DeploymentStatus - which is a character taking one of the following values:
#'    \itemize{
#'      \item{InDevelopment}
#'      \item{Deployed}
#'    }
#'   }
#'  \item{deprecated}{a character either 'true' or 'false'}
#'  \item{description}{a character}
#'  \item{enableActivities}{a character either 'true' or 'false'}
#'  \item{enableBulkApi}{a character either 'true' or 'false'}
#'  \item{enableChangeDataCapture}{a character either 'true' or 'false'}
#'  \item{enableDivisions}{a character either 'true' or 'false'}
#'  \item{enableEnhancedLookup}{a character either 'true' or 'false'}
#'  \item{enableFeeds}{a character either 'true' or 'false'}
#'  \item{enableHistory}{a character either 'true' or 'false'}
#'  \item{enableReports}{a character either 'true' or 'false'}
#'  \item{enableSearch}{a character either 'true' or 'false'}
#'  \item{enableSharing}{a character either 'true' or 'false'}
#'  \item{enableStreamingApi}{a character either 'true' or 'false'}
#'  \item{eventType}{a PlatformEventType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{HighVolume}
#'      \item{StandardVolume}
#'    }
#'   }
#'  \item{externalDataSource}{a character}
#'  \item{externalName}{a character}
#'  \item{externalRepository}{a character}
#'  \item{externalSharingModel}{a SharingModel - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Private}
#'      \item{Read}
#'      \item{ReadSelect}
#'      \item{ReadWrite}
#'      \item{ReadWriteTransfer}
#'      \item{FullAccess}
#'      \item{ControlledByParent}
#'    }
#'   }
#'  \item{fieldSets}{a FieldSet}
#'  \item{fields}{a CustomField}
#'  \item{gender}{a Gender - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Neuter}
#'      \item{Masculine}
#'      \item{Feminine}
#'      \item{AnimateMasculine}
#'    }
#'   }
#'  \item{historyRetentionPolicy}{a HistoryRetentionPolicy}
#'  \item{household}{a character either 'true' or 'false'}
#'  \item{indexes}{a Index}
#'  \item{label}{a character}
#'  \item{listViews}{a ListView}
#'  \item{nameField}{a CustomField}
#'  \item{pluralLabel}{a character}
#'  \item{recordTypeTrackFeedHistory}{a character either 'true' or 'false'}
#'  \item{recordTypeTrackHistory}{a character either 'true' or 'false'}
#'  \item{recordTypes}{a RecordType}
#'  \item{searchLayouts}{a SearchLayouts}
#'  \item{sharingModel}{a SharingModel - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Private}
#'      \item{Read}
#'      \item{ReadSelect}
#'      \item{ReadWrite}
#'      \item{ReadWriteTransfer}
#'      \item{FullAccess}
#'      \item{ControlledByParent}
#'    }
#'   }
#'  \item{sharingReasons}{a SharingReason}
#'  \item{sharingRecalculations}{a SharingRecalculation}
#'  \item{startsWith}{a StartsWith - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Consonant}
#'      \item{Vowel}
#'      \item{Special}
#'    }
#'   }
#'  \item{validationRules}{a ValidationRule}
#'  \item{visibility}{a SetupObjectVisibility - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Protected}
#'      \item{Public}
#'    }
#'   }
#'  \item{webLinks}{a WebLink}
#' }
#'
#' \strong{CustomObjectTranslation}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{caseValues}{a ObjectNameCaseValue}
#'  \item{fieldSets}{a FieldSetTranslation}
#'  \item{fields}{a CustomFieldTranslation}
#'  \item{gender}{a Gender - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Neuter}
#'      \item{Masculine}
#'      \item{Feminine}
#'      \item{AnimateMasculine}
#'    }
#'   }
#'  \item{layouts}{a LayoutTranslation}
#'  \item{nameFieldLabel}{a character}
#'  \item{quickActions}{a QuickActionTranslation}
#'  \item{recordTypes}{a RecordTypeTranslation}
#'  \item{sharingReasons}{a SharingReasonTranslation}
#'  \item{standardFields}{a StandardFieldTranslation}
#'  \item{startsWith}{a StartsWith - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Consonant}
#'      \item{Vowel}
#'      \item{Special}
#'    }
#'   }
#'  \item{validationRules}{a ValidationRuleTranslation}
#'  \item{webLinks}{a WebLinkTranslation}
#'  \item{workflowTasks}{a WorkflowTaskTranslation}
#' }
#'
#' \strong{CustomPageWebLink}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{availability}{a WebLinkAvailability - which is a character taking one of the following values:
#'    \itemize{
#'      \item{online}
#'      \item{offline}
#'    }
#'   }
#'  \item{description}{a character}
#'  \item{displayType}{a WebLinkDisplayType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{link}
#'      \item{button}
#'      \item{massActionButton}
#'    }
#'   }
#'  \item{encodingKey}{a Encoding - which is a character taking one of the following values:
#'    \itemize{
#'      \item{UTF-8}
#'      \item{ISO-8859-1}
#'      \item{Shift_JIS}
#'      \item{ISO-2022-JP}
#'      \item{EUC-JP}
#'      \item{ks_c_5601-1987}
#'      \item{Big5}
#'      \item{GB2312}
#'      \item{Big5-HKSCS}
#'      \item{x-SJIS_0213}
#'    }
#'   }
#'  \item{hasMenubar}{a character either 'true' or 'false'}
#'  \item{hasScrollbars}{a character either 'true' or 'false'}
#'  \item{hasToolbar}{a character either 'true' or 'false'}
#'  \item{height}{an integer}
#'  \item{isResizable}{a character either 'true' or 'false'}
#'  \item{linkType}{a WebLinkType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{url}
#'      \item{sControl}
#'      \item{javascript}
#'      \item{page}
#'      \item{flow}
#'    }
#'   }
#'  \item{masterLabel}{a character}
#'  \item{openType}{a WebLinkWindowType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{newWindow}
#'      \item{sidebar}
#'      \item{noSidebar}
#'      \item{replace}
#'      \item{onClickJavaScript}
#'    }
#'   }
#'  \item{page}{a character}
#'  \item{position}{a WebLinkPosition - which is a character taking one of the following values:
#'    \itemize{
#'      \item{fullScreen}
#'      \item{none}
#'      \item{topLeft}
#'    }
#'   }
#'  \item{protected}{a character either 'true' or 'false'}
#'  \item{requireRowSelection}{a character either 'true' or 'false'}
#'  \item{scontrol}{a character}
#'  \item{showsLocation}{a character either 'true' or 'false'}
#'  \item{showsStatus}{a character either 'true' or 'false'}
#'  \item{url}{a character}
#'  \item{width}{an integer}
#' }
#'
#' \strong{CustomPageWebLinkTranslation}
#'
#' \describe{
#'  \item{label}{a character}
#'  \item{name}{a character}
#' }
#'
#' \strong{CustomPermission}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{connectedApp}{a character}
#'  \item{description}{a character}
#'  \item{label}{a character}
#'  \item{requiredPermission}{a CustomPermissionDependencyRequired}
#' }
#'
#' \strong{CustomPermissionDependencyRequired}
#'
#' \describe{
#'  \item{customPermission}{a character}
#'  \item{dependency}{a character either 'true' or 'false'}
#' }
#'
#' \strong{CustomShortcut}
#'
#' \describe{
#'  \item{action}{a character (inherited from DefaultShortcut)}
#'  \item{active}{a character either 'true' or 'false' (inherited from DefaultShortcut)}
#'  \item{keyCommand}{a character (inherited from DefaultShortcut)}
#'  \item{description}{a character}
#'  \item{eventName}{a character}
#' }
#'
#' \strong{CustomSite}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{active}{a character either 'true' or 'false'}
#'  \item{allowHomePage}{a character either 'true' or 'false'}
#'  \item{allowStandardAnswersPages}{a character either 'true' or 'false'}
#'  \item{allowStandardIdeasPages}{a character either 'true' or 'false'}
#'  \item{allowStandardLookups}{a character either 'true' or 'false'}
#'  \item{allowStandardPortalPages}{a character either 'true' or 'false'}
#'  \item{allowStandardSearch}{a character either 'true' or 'false'}
#'  \item{analyticsTrackingCode}{a character}
#'  \item{authorizationRequiredPage}{a character}
#'  \item{bandwidthExceededPage}{a character}
#'  \item{browserXssProtection}{a character either 'true' or 'false'}
#'  \item{changePasswordPage}{a character}
#'  \item{chatterAnswersForgotPasswordConfirmPage}{a character}
#'  \item{chatterAnswersForgotPasswordPage}{a character}
#'  \item{chatterAnswersHelpPage}{a character}
#'  \item{chatterAnswersLoginPage}{a character}
#'  \item{chatterAnswersRegistrationPage}{a character}
#'  \item{clickjackProtectionLevel}{a SiteClickjackProtectionLevel - which is a character taking one of the following values:
#'    \itemize{
#'      \item{AllowAllFraming}
#'      \item{SameOriginOnly}
#'      \item{NoFraming}
#'    }
#'   }
#'  \item{contentSniffingProtection}{a character either 'true' or 'false'}
#'  \item{cspUpgradeInsecureRequests}{a character either 'true' or 'false'}
#'  \item{customWebAddresses}{a SiteWebAddress}
#'  \item{description}{a character}
#'  \item{favoriteIcon}{a character}
#'  \item{fileNotFoundPage}{a character}
#'  \item{forgotPasswordPage}{a character}
#'  \item{genericErrorPage}{a character}
#'  \item{guestProfile}{a character}
#'  \item{inMaintenancePage}{a character}
#'  \item{inactiveIndexPage}{a character}
#'  \item{indexPage}{a character}
#'  \item{masterLabel}{a character}
#'  \item{myProfilePage}{a character}
#'  \item{portal}{a character}
#'  \item{referrerPolicyOriginWhenCrossOrigin}{a character either 'true' or 'false'}
#'  \item{requireHttps}{a character either 'true' or 'false'}
#'  \item{requireInsecurePortalAccess}{a character either 'true' or 'false'}
#'  \item{robotsTxtPage}{a character}
#'  \item{rootComponent}{a character}
#'  \item{selfRegPage}{a character}
#'  \item{serverIsDown}{a character}
#'  \item{siteAdmin}{a character}
#'  \item{siteRedirectMappings}{a SiteRedirectMapping}
#'  \item{siteTemplate}{a character}
#'  \item{siteType}{a SiteType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Siteforce}
#'      \item{Visualforce}
#'      \item{User}
#'    }
#'   }
#'  \item{subdomain}{a character}
#'  \item{urlPathPrefix}{a character}
#' }
#'
#' \strong{CustomTab}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{actionOverrides}{a ActionOverride}
#'  \item{auraComponent}{a character}
#'  \item{customObject}{a character either 'true' or 'false'}
#'  \item{description}{a character}
#'  \item{flexiPage}{a character}
#'  \item{frameHeight}{an integer}
#'  \item{hasSidebar}{a character either 'true' or 'false'}
#'  \item{icon}{a character}
#'  \item{label}{a character}
#'  \item{mobileReady}{a character either 'true' or 'false'}
#'  \item{motif}{a character}
#'  \item{page}{a character}
#'  \item{scontrol}{a character}
#'  \item{splashPageLink}{a character}
#'  \item{url}{a character}
#'  \item{urlEncodingKey}{a Encoding - which is a character taking one of the following values:
#'    \itemize{
#'      \item{UTF-8}
#'      \item{ISO-8859-1}
#'      \item{Shift_JIS}
#'      \item{ISO-2022-JP}
#'      \item{EUC-JP}
#'      \item{ks_c_5601-1987}
#'      \item{Big5}
#'      \item{GB2312}
#'      \item{Big5-HKSCS}
#'      \item{x-SJIS_0213}
#'    }
#'   }
#' }
#'
#' \strong{CustomTabTranslation}
#'
#' \describe{
#'  \item{label}{a character}
#'  \item{name}{a character}
#' }
#'
#' \strong{CustomValue}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{color}{a character}
#'  \item{default}{a character either 'true' or 'false'}
#'  \item{description}{a character}
#'  \item{isActive}{a character either 'true' or 'false'}
#'  \item{label}{a character}
#' }
#'
#' \strong{Dashboard}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{backgroundEndColor}{a character}
#'  \item{backgroundFadeDirection}{a ChartBackgroundDirection - which is a character taking one of the following values:
#'    \itemize{
#'      \item{TopToBottom}
#'      \item{LeftToRight}
#'      \item{Diagonal}
#'    }
#'   }
#'  \item{backgroundStartColor}{a character}
#'  \item{chartTheme}{a ChartTheme - which is a character taking one of the following values:
#'    \itemize{
#'      \item{light}
#'      \item{dark}
#'    }
#'   }
#'  \item{colorPalette}{a ChartColorPalettes - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Default}
#'      \item{gray}
#'      \item{colorSafe}
#'      \item{unity}
#'      \item{justice}
#'      \item{nightfall}
#'      \item{sunrise}
#'      \item{bluegrass}
#'      \item{tropic}
#'      \item{heat}
#'      \item{dusk}
#'      \item{pond}
#'      \item{watermelon}
#'      \item{fire}
#'      \item{water}
#'      \item{earth}
#'      \item{accessible}
#'    }
#'   }
#'  \item{dashboardChartTheme}{a ChartTheme - which is a character taking one of the following values:
#'    \itemize{
#'      \item{light}
#'      \item{dark}
#'    }
#'   }
#'  \item{dashboardColorPalette}{a ChartColorPalettes - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Default}
#'      \item{gray}
#'      \item{colorSafe}
#'      \item{unity}
#'      \item{justice}
#'      \item{nightfall}
#'      \item{sunrise}
#'      \item{bluegrass}
#'      \item{tropic}
#'      \item{heat}
#'      \item{dusk}
#'      \item{pond}
#'      \item{watermelon}
#'      \item{fire}
#'      \item{water}
#'      \item{earth}
#'      \item{accessible}
#'    }
#'   }
#'  \item{dashboardFilters}{a DashboardFilter}
#'  \item{dashboardGridLayout}{a DashboardGridLayout}
#'  \item{dashboardResultRefreshedDate}{a character}
#'  \item{dashboardResultRunningUser}{a character}
#'  \item{dashboardType}{a DashboardType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{SpecifiedUser}
#'      \item{LoggedInUser}
#'      \item{MyTeamUser}
#'    }
#'   }
#'  \item{description}{a character}
#'  \item{folderName}{a character}
#'  \item{isGridLayout}{a character either 'true' or 'false'}
#'  \item{leftSection}{a DashboardComponentSection}
#'  \item{middleSection}{a DashboardComponentSection}
#'  \item{numSubscriptions}{an integer}
#'  \item{rightSection}{a DashboardComponentSection}
#'  \item{runningUser}{a character}
#'  \item{textColor}{a character}
#'  \item{title}{a character}
#'  \item{titleColor}{a character}
#'  \item{titleSize}{an integer}
#' }
#'
#' \strong{DashboardComponent}
#'
#' \describe{
#'  \item{autoselectColumnsFromReport}{a character either 'true' or 'false'}
#'  \item{chartAxisRange}{a ChartRangeType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Auto}
#'      \item{Manual}
#'    }
#'   }
#'  \item{chartAxisRangeMax}{a numeric}
#'  \item{chartAxisRangeMin}{a numeric}
#'  \item{chartSummary}{a ChartSummary}
#'  \item{componentChartTheme}{a ChartTheme - which is a character taking one of the following values:
#'    \itemize{
#'      \item{light}
#'      \item{dark}
#'    }
#'   }
#'  \item{componentType}{a DashboardComponentType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Bar}
#'      \item{BarGrouped}
#'      \item{BarStacked}
#'      \item{BarStacked100}
#'      \item{Column}
#'      \item{ColumnGrouped}
#'      \item{ColumnStacked}
#'      \item{ColumnStacked100}
#'      \item{Line}
#'      \item{LineGrouped}
#'      \item{Pie}
#'      \item{Table}
#'      \item{Metric}
#'      \item{Gauge}
#'      \item{LineCumulative}
#'      \item{LineGroupedCumulative}
#'      \item{Scontrol}
#'      \item{VisualforcePage}
#'      \item{Donut}
#'      \item{Funnel}
#'      \item{ColumnLine}
#'      \item{ColumnLineGrouped}
#'      \item{ColumnLineStacked}
#'      \item{ColumnLineStacked100}
#'      \item{Scatter}
#'      \item{ScatterGrouped}
#'      \item{FlexTable}
#'    }
#'   }
#'  \item{dashboardFilterColumns}{a DashboardFilterColumn}
#'  \item{dashboardTableColumn}{a DashboardTableColumn}
#'  \item{displayUnits}{a ChartUnits - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Auto}
#'      \item{Integer}
#'      \item{Hundreds}
#'      \item{Thousands}
#'      \item{Millions}
#'      \item{Billions}
#'      \item{Trillions}
#'    }
#'   }
#'  \item{drillDownUrl}{a character}
#'  \item{drillEnabled}{a character either 'true' or 'false'}
#'  \item{drillToDetailEnabled}{a character either 'true' or 'false'}
#'  \item{enableHover}{a character either 'true' or 'false'}
#'  \item{expandOthers}{a character either 'true' or 'false'}
#'  \item{flexComponentProperties}{a DashboardFlexTableComponentProperties}
#'  \item{footer}{a character}
#'  \item{gaugeMax}{a numeric}
#'  \item{gaugeMin}{a numeric}
#'  \item{groupingColumn}{a character}
#'  \item{header}{a character}
#'  \item{indicatorBreakpoint1}{a numeric}
#'  \item{indicatorBreakpoint2}{a numeric}
#'  \item{indicatorHighColor}{a character}
#'  \item{indicatorLowColor}{a character}
#'  \item{indicatorMiddleColor}{a character}
#'  \item{legendPosition}{a ChartLegendPosition - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Right}
#'      \item{Bottom}
#'      \item{OnChart}
#'    }
#'   }
#'  \item{maxValuesDisplayed}{an integer}
#'  \item{metricLabel}{a character}
#'  \item{page}{a character}
#'  \item{pageHeightInPixels}{an integer}
#'  \item{report}{a character}
#'  \item{scontrol}{a character}
#'  \item{scontrolHeightInPixels}{an integer}
#'  \item{showPercentage}{a character either 'true' or 'false'}
#'  \item{showPicturesOnCharts}{a character either 'true' or 'false'}
#'  \item{showPicturesOnTables}{a character either 'true' or 'false'}
#'  \item{showRange}{a character either 'true' or 'false'}
#'  \item{showTotal}{a character either 'true' or 'false'}
#'  \item{showValues}{a character either 'true' or 'false'}
#'  \item{sortBy}{a DashboardComponentFilter - which is a character taking one of the following values:
#'    \itemize{
#'      \item{RowLabelAscending}
#'      \item{RowLabelDescending}
#'      \item{RowValueAscending}
#'      \item{RowValueDescending}
#'    }
#'   }
#'  \item{title}{a character}
#'  \item{useReportChart}{a character either 'true' or 'false'}
#' }
#'
#' \strong{DashboardComponentColumn}
#'
#' \describe{
#'  \item{breakPoint1}{a numeric}
#'  \item{breakPoint2}{a numeric}
#'  \item{breakPointOrder}{an integer}
#'  \item{highRangeColor}{an integer}
#'  \item{lowRangeColor}{an integer}
#'  \item{midRangeColor}{an integer}
#'  \item{reportColumn}{a character}
#'  \item{showTotal}{a character either 'true' or 'false'}
#'  \item{type}{a DashboardComponentColumnType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{NA}
#'    }
#'   }
#' }
#'
#' \strong{DashboardComponentSection}
#'
#' \describe{
#'  \item{columnSize}{a DashboardComponentSize - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Narrow}
#'      \item{Medium}
#'      \item{Wide}
#'    }
#'   }
#'  \item{components}{a DashboardComponent}
#' }
#'
#' \strong{DashboardComponentSortInfo}
#'
#' \describe{
#'  \item{sortColumn}{a character}
#'  \item{sortOrder}{a character}
#' }
#'
#' \strong{DashboardFilter}
#'
#' \describe{
#'  \item{dashboardFilterOptions}{a DashboardFilterOption}
#'  \item{name}{a character}
#' }
#'
#' \strong{DashboardFilterColumn}
#'
#' \describe{
#'  \item{column}{a character}
#' }
#'
#' \strong{DashboardFilterOption}
#'
#' \describe{
#'  \item{operator}{a DashboardFilterOperation - which is a character taking one of the following values:
#'    \itemize{
#'      \item{equals}
#'      \item{notEqual}
#'      \item{lessThan}
#'      \item{greaterThan}
#'      \item{lessOrEqual}
#'      \item{greaterOrEqual}
#'      \item{contains}
#'      \item{notContain}
#'      \item{startsWith}
#'      \item{includes}
#'      \item{excludes}
#'      \item{between}
#'    }
#'   }
#'  \item{values}{a character}
#' }
#'
#' \strong{DashboardFlexTableComponentProperties}
#'
#' \describe{
#'  \item{flexTableColumn}{a DashboardComponentColumn}
#'  \item{flexTableSortInfo}{a DashboardComponentSortInfo}
#'  \item{hideChatterPhotos}{a character either 'true' or 'false'}
#' }
#'
#' \strong{DashboardFolder}
#'
#' \describe{
#'  \item{accessType}{a FolderAccessTypes (inherited from Folder)}
#'  \item{folderShares}{a FolderShare (inherited from Folder)}
#'  \item{name}{a character (inherited from Folder)}
#'  \item{publicFolderAccess}{a PublicFolderAccess (inherited from Folder)}
#'  \item{sharedTo}{a SharedTo (inherited from Folder)}
#' }
#'
#' \strong{DashboardGridComponent}
#'
#' \describe{
#'  \item{colSpan}{an integer}
#'  \item{columnIndex}{an integer}
#'  \item{dashboardComponent}{a DashboardComponent}
#'  \item{rowIndex}{an integer}
#'  \item{rowSpan}{an integer}
#' }
#'
#' \strong{DashboardGridLayout}
#'
#' \describe{
#'  \item{dashboardGridComponents}{a DashboardGridComponent}
#'  \item{numberOfColumns}{an integer}
#'  \item{rowHeight}{an integer}
#' }
#'
#' \strong{DashboardMobileSettings}
#'
#' \describe{
#'  \item{enableDashboardIPadApp}{a character either 'true' or 'false'}
#' }
#'
#' \strong{DashboardTableColumn}
#'
#' \describe{
#'  \item{aggregateType}{a ReportSummaryType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Sum}
#'      \item{Average}
#'      \item{Maximum}
#'      \item{Minimum}
#'      \item{None}
#'    }
#'   }
#'  \item{calculatePercent}{a character either 'true' or 'false'}
#'  \item{column}{a character}
#'  \item{decimalPlaces}{an integer}
#'  \item{showTotal}{a character either 'true' or 'false'}
#'  \item{sortBy}{a DashboardComponentFilter - which is a character taking one of the following values:
#'    \itemize{
#'      \item{RowLabelAscending}
#'      \item{RowLabelDescending}
#'      \item{RowValueAscending}
#'      \item{RowValueDescending}
#'    }
#'   }
#' }
#'
#' \strong{DataCategory}
#'
#' \describe{
#'  \item{dataCategory}{a DataCategory}
#'  \item{label}{a character}
#'  \item{name}{a character}
#' }
#'
#' \strong{DataCategoryGroup}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{active}{a character either 'true' or 'false'}
#'  \item{dataCategory}{a DataCategory}
#'  \item{description}{a character}
#'  \item{label}{a character}
#'  \item{objectUsage}{a ObjectUsage}
#' }
#'
#' \strong{DataPipeline}
#'
#' \describe{
#'  \item{content}{a character formed using \code{\link[base64enc]{base64encode}} (inherited from MetadataWithContent)}
#'  \item{apiVersion}{a numeric}
#'  \item{label}{a character}
#'  \item{scriptType}{a DataPipelineType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Pig}
#'    }
#'   }
#' }
#'
#' \strong{DefaultShortcut}
#'
#' \describe{
#'  \item{action}{a character}
#'  \item{active}{a character either 'true' or 'false'}
#'  \item{keyCommand}{a character}
#' }
#'
#' \strong{DelegateGroup}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{customObjects}{a character}
#'  \item{groups}{a character}
#'  \item{label}{a character}
#'  \item{loginAccess}{a character either 'true' or 'false'}
#'  \item{permissionSets}{a character}
#'  \item{profiles}{a character}
#'  \item{roles}{a character}
#' }
#'
#' \strong{DeployDetails}
#'
#' \describe{
#'  \item{componentFailures}{a DeployMessage}
#'  \item{componentSuccesses}{a DeployMessage}
#'  \item{retrieveResult}{a RetrieveResult}
#'  \item{runTestResult}{a RunTestsResult}
#' }
#'
#' \strong{DeployOptions}
#'
#' \describe{
#'  \item{allowMissingFiles}{a character either 'true' or 'false'}
#'  \item{autoUpdatePackage}{a character either 'true' or 'false'}
#'  \item{checkOnly}{a character either 'true' or 'false'}
#'  \item{ignoreWarnings}{a character either 'true' or 'false'}
#'  \item{performRetrieve}{a character either 'true' or 'false'}
#'  \item{purgeOnDelete}{a character either 'true' or 'false'}
#'  \item{rollbackOnError}{a character either 'true' or 'false'}
#'  \item{runTests}{a character}
#'  \item{singlePackage}{a character either 'true' or 'false'}
#'  \item{testLevel}{a TestLevel - which is a character taking one of the following values:
#'    \itemize{
#'      \item{NoTestRun}
#'      \item{RunSpecifiedTests}
#'      \item{RunLocalTests}
#'      \item{RunAllTestsInOrg}
#'    }
#'   }
#' }
#'
#' \strong{DescribeMetadataObject}
#'
#' \describe{
#'  \item{childXmlNames}{a character}
#'  \item{directoryName}{a character}
#'  \item{inFolder}{a character either 'true' or 'false'}
#'  \item{metaFile}{a character either 'true' or 'false'}
#'  \item{suffix}{a character}
#'  \item{xmlName}{a character}
#' }
#'
#' \strong{Document}
#'
#' \describe{
#'  \item{content}{a character formed using \code{\link[base64enc]{base64encode}} (inherited from MetadataWithContent)}
#'  \item{description}{a character}
#'  \item{internalUseOnly}{a character either 'true' or 'false'}
#'  \item{keywords}{a character}
#'  \item{name}{a character}
#'  \item{public}{a character either 'true' or 'false'}
#' }
#'
#' \strong{DocumentFolder}
#'
#' \describe{
#'  \item{accessType}{a FolderAccessTypes (inherited from Folder)}
#'  \item{folderShares}{a FolderShare (inherited from Folder)}
#'  \item{name}{a character (inherited from Folder)}
#'  \item{publicFolderAccess}{a PublicFolderAccess (inherited from Folder)}
#'  \item{sharedTo}{a SharedTo (inherited from Folder)}
#' }
#'
#' \strong{DuplicateRule}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{actionOnInsert}{a DupeActionType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Allow}
#'      \item{Block}
#'    }
#'   }
#'  \item{actionOnUpdate}{a DupeActionType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Allow}
#'      \item{Block}
#'    }
#'   }
#'  \item{alertText}{a character}
#'  \item{description}{a character}
#'  \item{duplicateRuleFilter}{a DuplicateRuleFilter}
#'  \item{duplicateRuleMatchRules}{a DuplicateRuleMatchRule}
#'  \item{isActive}{a character either 'true' or 'false'}
#'  \item{masterLabel}{a character}
#'  \item{operationsOnInsert}{a character}
#'  \item{operationsOnUpdate}{a character}
#'  \item{securityOption}{a DupeSecurityOptionType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{EnforceSharingRules}
#'      \item{BypassSharingRules}
#'    }
#'   }
#'  \item{sortOrder}{an integer}
#' }
#'
#' \strong{DuplicateRuleFilter}
#'
#' \describe{
#'  \item{booleanFilter}{a character}
#'  \item{duplicateRuleFilterItems}{a DuplicateRuleFilterItem}
#' }
#'
#' \strong{DuplicateRuleFilterItem}
#'
#' \describe{
#'  \item{field}{a character (inherited from FilterItem)}
#'  \item{operation}{a FilterOperation (inherited from FilterItem)}
#'  \item{value}{a character (inherited from FilterItem)}
#'  \item{valueField}{a character (inherited from FilterItem)}
#'  \item{sortOrder}{an integer}
#'  \item{table}{a character}
#' }
#'
#' \strong{DuplicateRuleMatchRule}
#'
#' \describe{
#'  \item{matchRuleSObjectType}{a character}
#'  \item{matchingRule}{a character}
#'  \item{objectMapping}{a ObjectMapping}
#' }
#'
#' \strong{EclairGeoData}
#'
#' \describe{
#'  \item{content}{a character formed using \code{\link[base64enc]{base64encode}} (inherited from MetadataWithContent)}
#'  \item{maps}{a EclairMap}
#'  \item{masterLabel}{a character}
#' }
#'
#' \strong{EclairMap}
#'
#' \describe{
#'  \item{boundingBoxBottom}{a numeric}
#'  \item{boundingBoxLeft}{a numeric}
#'  \item{boundingBoxRight}{a numeric}
#'  \item{boundingBoxTop}{a numeric}
#'  \item{mapLabel}{a character}
#'  \item{mapName}{a character}
#'  \item{projection}{a character}
#' }
#'
#' \strong{EmailFolder}
#'
#' \describe{
#'  \item{accessType}{a FolderAccessTypes (inherited from Folder)}
#'  \item{folderShares}{a FolderShare (inherited from Folder)}
#'  \item{name}{a character (inherited from Folder)}
#'  \item{publicFolderAccess}{a PublicFolderAccess (inherited from Folder)}
#'  \item{sharedTo}{a SharedTo (inherited from Folder)}
#' }
#'
#' \strong{EmailServicesAddress}
#'
#' \describe{
#'  \item{authorizedSenders}{a character}
#'  \item{developerName}{a character}
#'  \item{isActive}{a character either 'true' or 'false'}
#'  \item{localPart}{a character}
#'  \item{runAsUser}{a character}
#' }
#'
#' \strong{EmailServicesFunction}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{apexClass}{a character}
#'  \item{attachmentOption}{a EmailServicesAttOptions - which is a character taking one of the following values:
#'    \itemize{
#'      \item{None}
#'      \item{TextOnly}
#'      \item{BinaryOnly}
#'      \item{All}
#'      \item{NoContent}
#'    }
#'   }
#'  \item{authenticationFailureAction}{a EmailServicesErrorAction - which is a character taking one of the following values:
#'    \itemize{
#'      \item{UseSystemDefault}
#'      \item{Bounce}
#'      \item{Discard}
#'      \item{Requeue}
#'    }
#'   }
#'  \item{authorizationFailureAction}{a EmailServicesErrorAction - which is a character taking one of the following values:
#'    \itemize{
#'      \item{UseSystemDefault}
#'      \item{Bounce}
#'      \item{Discard}
#'      \item{Requeue}
#'    }
#'   }
#'  \item{authorizedSenders}{a character}
#'  \item{emailServicesAddresses}{a EmailServicesAddress}
#'  \item{errorRoutingAddress}{a character}
#'  \item{functionInactiveAction}{a EmailServicesErrorAction - which is a character taking one of the following values:
#'    \itemize{
#'      \item{UseSystemDefault}
#'      \item{Bounce}
#'      \item{Discard}
#'      \item{Requeue}
#'    }
#'   }
#'  \item{functionName}{a character}
#'  \item{isActive}{a character either 'true' or 'false'}
#'  \item{isAuthenticationRequired}{a character either 'true' or 'false'}
#'  \item{isErrorRoutingEnabled}{a character either 'true' or 'false'}
#'  \item{isTextAttachmentsAsBinary}{a character either 'true' or 'false'}
#'  \item{isTlsRequired}{a character either 'true' or 'false'}
#'  \item{overLimitAction}{a EmailServicesErrorAction - which is a character taking one of the following values:
#'    \itemize{
#'      \item{UseSystemDefault}
#'      \item{Bounce}
#'      \item{Discard}
#'      \item{Requeue}
#'    }
#'   }
#' }
#'
#' \strong{EmailTemplate}
#'
#' \describe{
#'  \item{content}{a character formed using \code{\link[base64enc]{base64encode}} (inherited from MetadataWithContent)}
#'  \item{apiVersion}{a numeric}
#'  \item{attachedDocuments}{a character}
#'  \item{attachments}{a Attachment}
#'  \item{available}{a character either 'true' or 'false'}
#'  \item{description}{a character}
#'  \item{encodingKey}{a Encoding - which is a character taking one of the following values:
#'    \itemize{
#'      \item{UTF-8}
#'      \item{ISO-8859-1}
#'      \item{Shift_JIS}
#'      \item{ISO-2022-JP}
#'      \item{EUC-JP}
#'      \item{ks_c_5601-1987}
#'      \item{Big5}
#'      \item{GB2312}
#'      \item{Big5-HKSCS}
#'      \item{x-SJIS_0213}
#'    }
#'   }
#'  \item{letterhead}{a character}
#'  \item{name}{a character}
#'  \item{packageVersions}{a PackageVersion}
#'  \item{relatedEntityType}{a character}
#'  \item{style}{a EmailTemplateStyle - which is a character taking one of the following values:
#'    \itemize{
#'      \item{none}
#'      \item{freeForm}
#'      \item{formalLetter}
#'      \item{promotionRight}
#'      \item{promotionLeft}
#'      \item{newsletter}
#'      \item{products}
#'    }
#'   }
#'  \item{subject}{a character}
#'  \item{textOnly}{a character}
#'  \item{type}{a EmailTemplateType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{text}
#'      \item{html}
#'      \item{custom}
#'      \item{visualforce}
#'    }
#'   }
#'  \item{uiType}{a EmailTemplateUiType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Aloha}
#'      \item{SFX}
#'      \item{SFX_Sample}
#'    }
#'   }
#' }
#'
#' \strong{EmailToCaseRoutingAddress}
#'
#' \describe{
#'  \item{addressType}{a EmailToCaseRoutingAddressType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{EmailToCase}
#'      \item{Outlook}
#'    }
#'   }
#'  \item{authorizedSenders}{a character}
#'  \item{caseOrigin}{a character}
#'  \item{caseOwner}{a character}
#'  \item{caseOwnerType}{a character}
#'  \item{casePriority}{a character}
#'  \item{createTask}{a character either 'true' or 'false'}
#'  \item{emailAddress}{a character}
#'  \item{emailServicesAddress}{a character}
#'  \item{isVerified}{a character either 'true' or 'false'}
#'  \item{routingName}{a character}
#'  \item{saveEmailHeaders}{a character either 'true' or 'false'}
#'  \item{taskStatus}{a character}
#' }
#'
#' \strong{EmailToCaseSettings}
#'
#' \describe{
#'  \item{enableE2CSourceTracking}{a character either 'true' or 'false'}
#'  \item{enableEmailToCase}{a character either 'true' or 'false'}
#'  \item{enableHtmlEmail}{a character either 'true' or 'false'}
#'  \item{enableOnDemandEmailToCase}{a character either 'true' or 'false'}
#'  \item{enableThreadIDInBody}{a character either 'true' or 'false'}
#'  \item{enableThreadIDInSubject}{a character either 'true' or 'false'}
#'  \item{notifyOwnerOnNewCaseEmail}{a character either 'true' or 'false'}
#'  \item{overEmailLimitAction}{a EmailToCaseOnFailureActionType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Bounce}
#'      \item{Discard}
#'      \item{Requeue}
#'    }
#'   }
#'  \item{preQuoteSignature}{a character either 'true' or 'false'}
#'  \item{routingAddresses}{a EmailToCaseRoutingAddress}
#'  \item{unauthorizedSenderAction}{a EmailToCaseOnFailureActionType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Bounce}
#'      \item{Discard}
#'      \item{Requeue}
#'    }
#'   }
#' }
#'
#' \strong{EmbeddedServiceBranding}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{contrastInvertedColor}{a character}
#'  \item{contrastPrimaryColor}{a character}
#'  \item{embeddedServiceConfig}{a character}
#'  \item{font}{a character}
#'  \item{masterLabel}{a character}
#'  \item{navBarColor}{a character}
#'  \item{primaryColor}{a character}
#'  \item{secondaryColor}{a character}
#' }
#'
#' \strong{EmbeddedServiceConfig}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{masterLabel}{a character}
#'  \item{site}{a character}
#' }
#'
#' \strong{EmbeddedServiceFieldService}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{appointmentBookingFlowName}{a character}
#'  \item{cancelApptBookingFlowName}{a character}
#'  \item{embeddedServiceConfig}{a character}
#'  \item{enabled}{a character either 'true' or 'false'}
#'  \item{fieldServiceConfirmCardImg}{a character}
#'  \item{fieldServiceHomeImg}{a character}
#'  \item{fieldServiceLogoImg}{a character}
#'  \item{masterLabel}{a character}
#'  \item{modifyApptBookingFlowName}{a character}
#'  \item{shouldShowExistingAppointment}{a character either 'true' or 'false'}
#'  \item{shouldShowNewAppointment}{a character either 'true' or 'false'}
#' }
#'
#' \strong{EmbeddedServiceLiveAgent}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{avatarImg}{a character}
#'  \item{customPrechatComponent}{a character}
#'  \item{embeddedServiceConfig}{a character}
#'  \item{embeddedServiceQuickActions}{a EmbeddedServiceQuickAction}
#'  \item{enabled}{a character either 'true' or 'false'}
#'  \item{fontSize}{a EmbeddedServiceFontSize - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Small}
#'      \item{Medium}
#'      \item{Large}
#'    }
#'   }
#'  \item{headerBackgroundImg}{a character}
#'  \item{liveAgentChatUrl}{a character}
#'  \item{liveAgentContentUrl}{a character}
#'  \item{liveChatButton}{a character}
#'  \item{liveChatDeployment}{a character}
#'  \item{masterLabel}{a character}
#'  \item{prechatBackgroundImg}{a character}
#'  \item{prechatEnabled}{a character either 'true' or 'false'}
#'  \item{prechatJson}{a character}
#'  \item{scenario}{a EmbeddedServiceScenario - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Sales}
#'      \item{Service}
#'      \item{Basic}
#'    }
#'   }
#'  \item{smallCompanyLogoImg}{a character}
#'  \item{waitingStateBackgroundImg}{a character}
#' }
#'
#' \strong{EmbeddedServiceQuickAction}
#'
#' \describe{
#'  \item{embeddedServiceLiveAgent}{a character}
#'  \item{order}{an integer}
#'  \item{quickActionDefinition}{a character}
#' }
#'
#' \strong{EntitlementProcess}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{SObjectType}{a character}
#'  \item{active}{a character either 'true' or 'false'}
#'  \item{businessHours}{a character}
#'  \item{description}{a character}
#'  \item{entryStartDateField}{a character}
#'  \item{exitCriteriaBooleanFilter}{a character}
#'  \item{exitCriteriaFilterItems}{a FilterItem}
#'  \item{exitCriteriaFormula}{a character}
#'  \item{isRecordTypeApplied}{a character either 'true' or 'false'}
#'  \item{isVersionDefault}{a character either 'true' or 'false'}
#'  \item{milestones}{a EntitlementProcessMilestoneItem}
#'  \item{name}{a character}
#'  \item{recordType}{a character}
#'  \item{versionMaster}{a character}
#'  \item{versionNotes}{a character}
#'  \item{versionNumber}{an integer}
#' }
#'
#' \strong{EntitlementProcessMilestoneItem}
#'
#' \describe{
#'  \item{businessHours}{a character}
#'  \item{criteriaBooleanFilter}{a character}
#'  \item{milestoneCriteriaFilterItems}{a FilterItem}
#'  \item{milestoneCriteriaFormula}{a character}
#'  \item{milestoneName}{a character}
#'  \item{minutesCustomClass}{a character}
#'  \item{minutesToComplete}{an integer}
#'  \item{successActions}{a WorkflowActionReference}
#'  \item{timeTriggers}{a EntitlementProcessMilestoneTimeTrigger}
#'  \item{useCriteriaStartTime}{a character either 'true' or 'false'}
#' }
#'
#' \strong{EntitlementProcessMilestoneTimeTrigger}
#'
#' \describe{
#'  \item{actions}{a WorkflowActionReference}
#'  \item{timeLength}{an integer}
#'  \item{workflowTimeTriggerUnit}{a MilestoneTimeUnits - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Minutes}
#'      \item{Hours}
#'      \item{Days}
#'    }
#'   }
#' }
#'
#' \strong{EntitlementSettings}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{assetLookupLimitedToActiveEntitlementsOnAccount}{a character either 'true' or 'false'}
#'  \item{assetLookupLimitedToActiveEntitlementsOnContact}{a character either 'true' or 'false'}
#'  \item{assetLookupLimitedToSameAccount}{a character either 'true' or 'false'}
#'  \item{assetLookupLimitedToSameContact}{a character either 'true' or 'false'}
#'  \item{enableEntitlementVersioning}{a character either 'true' or 'false'}
#'  \item{enableEntitlements}{a character either 'true' or 'false'}
#'  \item{entitlementLookupLimitedToActiveStatus}{a character either 'true' or 'false'}
#'  \item{entitlementLookupLimitedToSameAccount}{a character either 'true' or 'false'}
#'  \item{entitlementLookupLimitedToSameAsset}{a character either 'true' or 'false'}
#'  \item{entitlementLookupLimitedToSameContact}{a character either 'true' or 'false'}
#' }
#'
#' \strong{EntitlementTemplate}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{businessHours}{a character}
#'  \item{casesPerEntitlement}{an integer}
#'  \item{entitlementProcess}{a character}
#'  \item{isPerIncident}{a character either 'true' or 'false'}
#'  \item{term}{an integer}
#'  \item{type}{a character}
#' }
#'
#' \strong{EscalationAction}
#'
#' \describe{
#'  \item{assignedTo}{a character}
#'  \item{assignedToTemplate}{a character}
#'  \item{assignedToType}{a AssignToLookupValueType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{User}
#'      \item{Queue}
#'    }
#'   }
#'  \item{minutesToEscalation}{an integer}
#'  \item{notifyCaseOwner}{a character either 'true' or 'false'}
#'  \item{notifyEmail}{a character}
#'  \item{notifyTo}{a character}
#'  \item{notifyToTemplate}{a character}
#' }
#'
#' \strong{EscalationRule}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{active}{a character either 'true' or 'false'}
#'  \item{ruleEntry}{a RuleEntry}
#' }
#'
#' \strong{EscalationRules}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{escalationRule}{a EscalationRule}
#' }
#'
#' \strong{EventDelivery}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{eventParameters}{a EventParameterMap}
#'  \item{eventSubscription}{a character}
#'  \item{referenceData}{a character}
#'  \item{type}{a EventDeliveryType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{StartFlow}
#'      \item{ResumeFlow}
#'    }
#'   }
#' }
#'
#' \strong{EventParameterMap}
#'
#' \describe{
#'  \item{parameterName}{a character}
#'  \item{parameterValue}{a character}
#' }
#'
#' \strong{EventSubscription}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{active}{a character either 'true' or 'false'}
#'  \item{eventParameters}{a EventParameterMap}
#'  \item{eventType}{a character}
#'  \item{referenceData}{a character}
#' }
#'
#' \strong{ExtendedErrorDetails}
#'
#' \describe{
#'  \item{extendedErrorCode}{a ExtendedErrorCode - which is a character taking one of the following values:
#'    \itemize{
#'      \item{ACTIONCALL_DUPLICATE_INPUT_PARAM - Errors with this extended error code have the following properties:
#' actionCallName, parameterName}
#'      \item{ACTIONCALL_DUPLICATE_OUTPUT_PARAM - Errors with this extended error code have the following properties:
#' actionCallName, parameterName}
#'      \item{ACTIONCALL_MISSING_NAME - Errors with this extended error code have the following properties:}
#'      \item{ACTIONCALL_MISSING_REQUIRED_PARAM - Errors with this extended error code have the following properties:
#' actionCallName, parameterName}
#'      \item{ACTIONCALL_MISSING_REQUIRED_TYPE - Errors with this extended error code have the following properties:
#' actionCallName}
#'      \item{ACTIONCALL_NOT_FOUND_WITH_NAME_AND_TYPE - Errors with this extended error code have the following properties:}
#'      \item{ACTIONCALL_NOT_SUPPORTED_FOR_PROCESSTYPE - Errors with this extended error code have the following properties:
#' processType}
#'      \item{APEXCALLOUT_INPUT_DUPLICATE - Errors with this extended error code have the following properties:
#' apexClassName, parameterName}
#'      \item{APEXCALLOUT_INPUT_INCOMPATIBLE_DATATYPE - Errors with this extended error code have the following properties:
#' apexClassName, parameterName}
#'      \item{APEXCALLOUT_INVALID - Errors with this extended error code have the following properties:
#' apexClassName}
#'      \item{APEXCALLOUT_MISSING_CLASSNAME - Errors with this extended error code have the following properties:
#' apexClassName}
#'      \item{APEXCALLOUT_NOT_FOUND - Errors with this extended error code have the following properties:
#' apexClassName}
#'      \item{APEXCALLOUT_OUTPUT_INCOMPATIBLE_DATATYPE - Errors with this extended error code have the following properties:
#' apexClassName, parameterName}
#'      \item{APEXCALLOUT_OUTPUT_NOT_FOUND - Errors with this extended error code have the following properties:
#' apexClassName, parameterName}
#'      \item{APEXCALLOUT_REQUIRED_INPUT_MISSING - Errors with this extended error code have the following properties:
#' apexClassName, parameterName}
#'      \item{APEXCLASS_MISSING_INTERFACE - Errors with this extended error code have the following properties:
#' apexClassName, parentScreenFieldName}
#'      \item{ASSIGNMENTITEM_ELEMENT_MISSING_DATATYPE - Errors with this extended error code have the following properties:
#' assignmentName, operatorName, elementName}
#'      \item{ASSIGNMENTITEM_ELEMENT_NOT_SUPPORTED - Errors with this extended error code have the following properties:
#' elementName, assignmentName, elementType}
#'      \item{ASSIGNMENTITEM_FIELD_INVALID_DATATYPE - Errors with this extended error code have the following properties:
#' fieldValue, dataType, incompatibleDataType}
#'      \item{ASSIGNMENTITEM_FIELD_INVALID_DATATYPE_WITH_ELEMENT - Errors with this extended error code have the following properties:
#' elementName, acceptedDataType, dataType, fieldValue}
#'      \item{ASSIGNMENTITEM_INCOMPATIBLE_DATATYPES - Errors with this extended error code have the following properties:
#' assignmentName, operatorName, leftElementName, leftElementType,
#' rightElementName, rightElementType}
#'      \item{ASSIGNMENTITEM_INVALID_COLLECTION - Errors with this extended error code have the following properties:
#' assignmentName, operatorName, leftElementName, rightElementName}
#'      \item{ASSIGNMENTITEM_INVALID_DATATYPE_IN_ELEMENT - Errors with this extended error code have the following properties:
#' elementName, dataType, incompatibleDataType}
#'      \item{ASSIGNMENTITEM_INVALID_REFERENCE - Errors with this extended error code have the following properties:
#' parameterName, operatorName}
#'      \item{ASSIGNMENTITEM_LEFT_DATATYPE_INVALID_FOR_OPERATOR - Errors with this extended error code have the following properties:
#' assignmentName, operatorName, dataType, elementName}
#'      \item{ASSIGNMENTITEM_MODIFIES_NONVARIABLE - Errors with this extended error code have the following properties:
#' assignmentName}
#'      \item{ASSIGNMENTITEM_NONEXISTENT_REFERENCE - Errors with this extended error code have the following properties:
#' parameterName, operatorName}
#'      \item{ASSIGNMENTITEM_REQUIRED - Errors with this extended error code have the following properties:
#' assignmentName}
#'      \item{ASSIGNMENTITEM_RIGHT_DATATYPE_INVALID_FOR_OPERATOR - Errors with this extended error code have the following properties:
#' elementName}
#'      \item{AUTOLAUNCHED_CHOICELOOKUP_NOT_SUPPORTED - Errors with this extended error code have the following properties:
#' choiceLookupName}
#'      \item{AUTOLAUNCHED_CHOICE_NOT_SUPPORTED - Errors with this extended error code have the following properties:
#' choiceName}
#'      \item{AUTOLAUNCHED_SCREEN_NOT_SUPPORTED - Errors with this extended error code have the following properties:}
#'      \item{AUTOLAUNCHED_STEP_NOT_SUPPORTED - Errors with this extended error code have the following properties:}
#'      \item{AUTOLAUNCHED_SUBFLOW_INCOMPATIBLE_FLOWTYPE - Errors with this extended error code have the following properties:
#' subflowType}
#'      \item{AUTOLAUNCHED_WAIT_NOT_SUPPORTED - Errors with this extended error code have the following properties:}
#'      \item{CHOICEFIELD_DEFAULT_CHOICE_NOT_FOUND - Errors with this extended error code have the following properties:
#' screenFieldName}
#'      \item{CHOICEFIELD_MISSING_CHOICE - Errors with this extended error code have the following properties:
#' questionName}
#'      \item{CHOICELOOKUP_DATATYPE_INCOMPATIBLE_WITH_CHOICEFIELD - Errors with this extended error code have the following properties:
#' choiceName, parentScreenFieldName}
#'      \item{CHOICE_DATATYPE_INCOMPATIBLE_WITH_CHOICEFIELD - Errors with this extended error code have the following properties:
#' choiceName, parentScreenFieldName}
#'      \item{CHOICE_NOT_SUPPORTED_FOR_SCREENFIELDTYPE - Errors with this extended error code have the following properties:
#' elementName, screenFieldName}
#'      \item{CHOICE_USED_MULTIPLE_TIMES_IN_SAME_FIELD - Errors with this extended error code have the following properties:
#' choiceName}
#'      \item{CONDITION_DATATYPE_INCOMPATIBLE - Errors with this extended error code have the following properties:
#' leftElementName, leftElementType, operatorName, rightElementName,
#' rightElementType, ruleName}
#'      \item{CONDITION_DATATYPE_INCOMPATIBLE_WITH_ELEMENT - Errors with this extended error code have the following properties:
#' elementName, dataType, operatorName, parameterName, ruleName}
#'      \item{CONDITION_ELEMENT_DATATYPES_INCOMPATIBLE - Errors with this extended error code have the following properties:
#' elementName, leftElementType, operatorName, rightElementType, ruleName}
#'      \item{CONDITION_INVALID_LEFTOPERAND - Errors with this extended error code have the following properties: ruleName}
#'      \item{CONDITION_INVALID_LEFT_ELEMENT - Errors with this extended error code have the following properties:
#' elementName, dataType, operatorName, parameterName, ruleName}
#'      \item{CONDITION_LOGIC_EXCEEDS_LIMIT - Errors with this extended error code have the following properties:
#' elementName, characterLimit}
#'      \item{CONDITION_LOGIC_INVALID - Errors with this extended error code have the following properties:
#' elementName}
#'      \item{CONDITION_LOGIC_MISSING - Errors with this extended error code have the following properties:
#' elementName}
#'      \item{CONDITION_MISSING_DATATYPE - Errors with this extended error code have the following properties:
#' elementName, dataType, operatorName, parameterName, ruleName}
#'      \item{CONDITION_MISSING_OPERATOR - Errors with this extended error code have the following properties: ruleName}
#'      \item{CONDITION_REFERENCED_ELEMENT_NOT_FOUND - Errors with this extended error code have the following properties: ruleName}
#'      \item{CONDITION_RIGHTOPERAND_NULL - Errors with this extended error code have the following properties: ruleName}
#'      \item{CONNECTOR_MISSING_TARGET - Errors with this extended error code have the following properties:
#' elementName}
#'      \item{CONSTANT_INCLUDES_REFERENCES - Errors with this extended error code have the following properties:
#' constantName}
#'      \item{CUSTOMEVENTS_NOT_ENABLED - Errors with this extended error code have the following properties:}
#'      \item{CUSTOMEVENT_MISSING_PROCESSMETADATAVALUES - Errors with this extended error code have the following properties:}
#'      \item{CUSTOMEVENT_OBJECTTYPE_NOT_FOUND - Errors with this extended error code have the following properties:
#' objectType}
#'      \item{CUSTOMEVENT_OBJECTTYPE_NOT_SUPPORTED - Errors with this extended error code have the following properties:
#' objectType}
#'      \item{CUSTOMEVENT_PROCESSMETADATAVALUES_MISSING_NAME - Errors with this extended error code have the following properties:
#' metadataValue}
#'      \item{CUSTOMEVENT_PROCESSMETADATAVALUES_MORE_THAN_ONE_NAME - Errors with this extended error code have the following properties:
#' metadataValue}
#'      \item{DATATYPE_INVALID - Errors with this extended error code have the following properties:
#' elementName, dataType}
#'      \item{DATATYPE_MISSING - Errors with this extended error code have the following properties:
#' elementName}
#'      \item{DECISION_DEFAULT_CONNECTOR_MISSING_LABEL - Errors with this extended error code have the following properties:
#' flowDecision}
#'      \item{DECISION_MISSING_OUTCOME - Errors with this extended error code have the following properties:
#' flowDecision}
#'      \item{ELEMENT_CONNECTS_TO_SELF - Errors with this extended error code have the following properties:
#' elementName}
#'      \item{ELEMENT_COORDINATES_INVALID - Errors with this extended error code have the following properties:
#' coordinateLimit, coordinateName}
#'      \item{ELEMENT_INVALID_CONNECTOR - Errors with this extended error code have the following properties:
#' elementName}
#'      \item{ELEMENT_INVALID_REFERENCE - Errors with this extended error code have the following properties:
#' elementName}
#'      \item{ELEMENT_MISSING_CONNECTOR - Errors with this extended error code have the following properties:
#' elementName}
#'      \item{ELEMENT_MISSING_LABEL - Errors with this extended error code have the following properties:
#' characterLimit, elementName}
#'      \item{ELEMENT_MISSING_NAME - Errors with this extended error code have the following properties:
#' characterLimit}
#'      \item{ELEMENT_MISSING_REFERENCE - Errors with this extended error code have the following properties:
#' elementName}
#'      \item{ELEMENT_MORE_THAN_ONE_FIELD - Errors with this extended error code have the following properties:
#' elementName}
#'      \item{ELEMENT_NAME_INVALID - Errors with this extended error code have the following properties:}
#'      \item{ELEMENT_NEVER_USED - Errors with this extended error code have the following properties:
#' elementName}
#'      \item{ELEMENT_SCALE_SMALLER_THAN_DEFAULTVALUE - Errors with this extended error code have the following properties:
#' elementName}
#'      \item{EXTERNAL_OBJECTS_NOT_SUPPORTED - Errors with this extended error code have the following properties:
#' objectName}
#'      \item{EXTERNAL_OBJECT_FIELDS_NOT_SUPPORTED - Errors with this extended error code have the following properties:
#' fieldReference}
#'      \item{FIELDASSIGNMENT_FIELD_INCOMPATIBLE_DATATYPE - Errors with this extended error code have the following properties:
#' fieldName, elementName}
#'      \item{FIELDASSIGNMENT_INVALID_DATATYPE - Errors with this extended error code have the following properties:
#' fieldName, elementName, assignmentName}
#'      \item{FIELDASSIGNMENT_INVALID_ELEMENT - Errors with this extended error code have the following properties:
#' fieldName, elementName, elementType}
#'      \item{FIELDASSIGNMENT_INVALID_REFERENCE - Errors with this extended error code have the following properties:
#' fieldName, parameterName}
#'      \item{FIELDASSIGNMENT_MULTIPLE_REFERENCES_SAME_FIELD - Errors with this extended error code have the following properties:
#' fieldName}
#'      \item{FIELDASSIGNMENT_PICKLISTFIELD_INCOMPATIBLE_DATATYPE - Errors with this extended error code have the following properties:
#' fieldName, dataType}
#'      \item{FIELDASSIGNMENT_REFERENCED_ELEMENT_MISSING_DATATYPE - Errors with this extended error code have the following properties:
#' fieldName, elementName, elementType}
#'      \item{FIELDSERVICE_UNSUPPORTED_FIELD_TYPE - Errors with this extended error code have the following properties:
#' elementName}
#'      \item{FIELD_INVALID_VALUE - Errors with this extended error code have the following properties:
#' fieldName, parameterName}
#'      \item{FIELD_NOT_FOUND - Errors with this extended error code have the following properties:
#' objectName, fieldName}
#'      \item{FIELD_RELATIONSHIP_NOT_SUPPORTED - Errors with this extended error code have the following properties:
#' fieldRelationshipName}
#'      \item{FLEXIPAGE_COMPONENT_ATTRIBUTE_EXPRESSION_EXCEPTION - Errors with this extended error code have the following properties:
#' componentName, propertyName, propertyType, errorCode, invalidTokens}
#'      \item{FLEXIPAGE_COMPONENT_ATTRIBUTE_GENERIC_EXCEPTION - Errors with this extended error code have the following properties:
#' componentName, propertyName, propertyType, errorIdentifier, errorParams}
#'      \item{FLEXIPAGE_COMPONENT_ATTRIBUTE_MISSING_REQUIRED - Errors with this extended error code have the following properties:
#' componentName, propertyName, propertyType}
#'      \item{FLEXIPAGE_COMPONENT_ATTRIBUTE_TOO_LONG - Errors with this extended error code have the following properties:
#' componentName, propertyName, propertyType, maxLength}
#'      \item{FLEXIPAGE_COMPONENT_MAX_LIMIT_EXCEPTION - Errors with this extended error code have the following properties:}
#'      \item{FLEXIPAGE_COMPONENT_RULE_VALIDATION_EXCEPTION - Errors with this extended error code have the following properties:
#' componentName, criterionIndex}
#'      \item{FLEXIPAGE_PICKLIST_INVALID_VALUE_EXCEPTION - Errors with this extended error code have the following properties:
#' componentName, propertyName, propertyType, invalidValue}
#'      \item{FLOW_INCLUDES_STEP - Errors with this extended error code have the following properties:
#' elementName}
#'      \item{FLOW_NAME_USED_IN_OTHER_CLIENT - Errors with this extended error code have the following properties: flowName}
#'      \item{FLOW_STAGE_INCLUDES_REFERENCES - Errors with this extended error code have the following properties:
#' stageName}
#'      \item{FORMULA_EXPRESSION_INVALID - Errors with this extended error code have the following properties:
#' formulaExpression}
#'      \item{INPUTPARAM_INCOMPATIBLE_DATATYPE - Errors with this extended error code have the following properties:
#' parameterName}
#'      \item{INPUTPARAM_INCOMPATIBLE_WITH_COLLECTION_VARIABLE - Errors with this extended error code have the following properties:
#' parameterName}
#'      \item{INPUTPARAM_INCOMPATIBLE_WITH_NONCOLLECTION_VARIABLE - Errors with this extended error code have the following properties:
#' parameterName}
#'      \item{INPUTPARAM_MISMATCHED_OBJECTTYPE - Errors with this extended error code have the following properties:
#' parameterName}
#'      \item{INVALID_FLOW - Errors with this extended error code have the following properties:}
#'      \item{INVALID_SURVEY_VARIABLE_NAME_OR_TYPE - Errors with this extended error code have the following properties:
#' surveyName}
#'      \item{LOOP_ASSIGNNEXTVALUETO_MISMATCHED_DATATYPE - Errors with this extended error code have the following properties:
#' elementName}
#'      \item{LOOP_ASSIGNNEXTVALUETO_MISMATCHED_OBJECTTYPE - Errors with this extended error code have the following properties:
#' elementName}
#'      \item{LOOP_ASSIGNNEXTVALUETO_MISSING - Errors with this extended error code have the following properties:
#' elementName}
#'      \item{LOOP_ASSIGNNEXTVALUETO_MISSING_VARIABLE - Errors with this extended error code have the following properties:
#' elementName}
#'      \item{LOOP_ASSIGNNEXTVALUETO_REFERENCE_NOT_FOUND - Errors with this extended error code have the following properties:
#' fieldRelationshipName}
#'      \item{LOOP_COLLECTION_ELEMENT_NOT_FOUND - Errors with this extended error code have the following properties:
#' elementName}
#'      \item{LOOP_COLLECTION_NOT_FOUND - Errors with this extended error code have the following properties:
#' elementName}
#'      \item{LOOP_COLLECTION_NOT_SUPPORTED_FOR_FIELD - Errors with this extended error code have the following properties:
#' fieldName}
#'      \item{LOOP_MISSING_COLLECTION - Errors with this extended error code have the following properties:}
#'      \item{OBJECTTYPE_INVALID - Errors with this extended error code have the following properties:
#' objectType}
#'      \item{OBJECT_CANNOT_BE_CREATED - Errors with this extended error code have the following properties:
#' objectName}
#'      \item{OBJECT_CANNOT_BE_DELETED - Errors with this extended error code have the following properties:
#' objectName}
#'      \item{OBJECT_CANNOT_BE_QUERIED - Errors with this extended error code have the following properties:
#' objectName}
#'      \item{OBJECT_CANNOT_BE_UPDATED - Errors with this extended error code have the following properties:
#' objectName}
#'      \item{OBJECT_ENCRYPTED_FIELDS_NOT_SUPPORTED - Errors with this extended error code have the following properties:
#' fieldName}
#'      \item{OBJECT_NOT_FOUND - Errors with this extended error code have the following properties:
#' objectName}
#'      \item{OUTPUTPARAM_ASSIGNTOREFERENCE_NOTFOUND - Errors with this extended error code have the following properties:
#' parameterName}
#'      \item{OUTPUTPARAM_INCOMPATIBLE_DATATYPE - Errors with this extended error code have the following properties:
#' parameterName}
#'      \item{OUTPUTPARAM_MISMATCHED_OBJECTTYPE - Errors with this extended error code have the following properties:
#' parameterName}
#'      \item{OUTPUTPARAM_MISMATCHED_WITH_COLLECTION_VARIABLE - Errors with this extended error code have the following properties:
#' parameterName}
#'      \item{OUTPUTPARAM_MISSING_ASSIGNTOREFERENCE - Errors with this extended error code have the following properties:
#' parameterName}
#'      \item{OUTPUTPARAM_MISTMATCHED_WITH_NONCOLLECTION_VARIABLE - Errors with this extended error code have the following properties:
#' parameterName}
#'      \item{PARAM_DATATYPE_NOT_SUPPORTED - Errors with this extended error code have the following properties:
#' parameterName}
#'      \item{PROCESSMETADATAVALUES_NOT_SUPPORTED_FOR_PROCESSTYPE - Errors with this extended error code have the following properties:
#' processType, metadataValue}
#'      \item{PROCESSMETADATAVALUE_NONEXISTENT_ELEMENT - Errors with this extended error code have the following properties:
#' metadataValue}
#'      \item{PROCESSTYPE_ELEMENT_NOT_SUPPORTED - Errors with this extended error code have the following properties:
#' processType, elementType}
#'      \item{PROCESSTYPE_NOT_SUPPORTED - Errors with this extended error code have the following properties:
#' processType}
#'      \item{RECORDFILTER_ENCRYPTED_FIELDS_NOT_SUPPORTED - Errors with this extended error code have the following properties:
#' fieldName}
#'      \item{RECORDFILTER_GEOLOCATION_FIELDS_NOT_SUPPORTED - Errors with this extended error code have the following properties:
#' fieldName, objectName}
#'      \item{RECORDFILTER_INVALID_DATATYPE - Errors with this extended error code have the following properties:
#' fieldName, elementName, elementType, operatorName}
#'      \item{RECORDFILTER_INVALID_ELEMENT - Errors with this extended error code have the following properties:
#' fieldName, assignmentName, elementName, elementType}
#'      \item{RECORDFILTER_INVALID_OPERATOR - Errors with this extended error code have the following properties:
#' fieldName, operatorName}
#'      \item{RECORDFILTER_INVALID_REFERENCE - Errors with this extended error code have the following properties:
#' fieldName, operatorName}
#'      \item{RECORDFILTER_MISSING_DATATYPE - Errors with this extended error code have the following properties:
#' fieldName, elementName, elementType, operatorName}
#'      \item{RECORDFILTER_MULTIPLE_QUERIES_SAME_FIELD - Errors with this extended error code have the following properties:
#' fieldName}
#'      \item{RECORDLOOKUP_IDASSIGNMENT_VARIABLE_INCOMPATIBLE_DATATYPE - Errors with this extended error code have the following properties:
#' elementName}
#'      \item{RECORDLOOKUP_IDASSIGNMENT_VARIABLE_NOT_FOUND - Errors with this extended error code have the following properties:
#' elementName}
#'      \item{RECORDUPDATE_MISSING_FILTERS - Errors with this extended error code have the following properties:
#' objectName}
#'      \item{REFERENCED_ELEMENT_NOT_FOUND - Errors with this extended error code have the following properties:
#' elementName, mergeFieldReference}
#'      \item{RULE_MISSING_CONDITION - Errors with this extended error code have the following properties:
#' elementName, ruleName}
#'      \item{SCREENFIELD_BOOLEAN_ISREQUIRED_IS_FALSE - Errors with this extended error code have the following properties:
#' fieldName}
#'      \item{SCREENFIELD_DEFAULTVALUE_NOT_SUPPORTED - Errors with this extended error code have the following properties:
#' elementName}
#'      \item{SCREENFIELD_EXTENSION_COMPONENT_NOT_GLOBAL - Errors with this extended error code have the following properties:
#' elementName}
#'      \item{SCREENFIELD_EXTENSION_DUPLICATE_INPUT_PARAM - Errors with this extended error code have the following properties:
#' elementName, extensionName, parameterName}
#'      \item{SCREENFIELD_EXTENSION_DUPLICATE_OUTPUT_PARAM - Errors with this extended error code have the following properties:
#' elementName, extensionName, parameterName}
#'      \item{SCREENFIELD_EXTENSION_IMPLEMENTATION_INVALID - Errors with this extended error code have the following properties:
#' elementName, extensionName}
#'      \item{SCREENFIELD_EXTENSION_INPUT_ATTRIBUTE_INVALID - Errors with this extended error code have the following properties:
#' elementName, extensionName, parameterName}
#'      \item{SCREENFIELD_EXTENSION_NAME_INVALID - Errors with this extended error code have the following properties:
#' elementName, extensionName}
#'      \item{SCREENFIELD_EXTENSION_NAME_MISSING - Errors with this extended error code have the following properties:
#' elementName, fieldType}
#'      \item{SCREENFIELD_EXTENSION_NAME_NOT_SUPPORTED - Errors with this extended error code have the following properties:
#' elementName, fieldType}
#'      \item{SCREENFIELD_EXTENSION_OUTPUT_ATTRIBUTE_INVALID - Errors with this extended error code have the following properties:
#' elementName, extensionName, parameterName}
#'      \item{SCREENFIELD_EXTENSION_REQUIRED_INPUT_MISSING - Errors with this extended error code have the following properties:
#' elementName, extensionName, parameterName}
#'      \item{SCREENFIELD_INPUTS_NOT_SUPPORTED - Errors with this extended error code have the following properties:
#' elementName, fieldType}
#'      \item{SCREENFIELD_INVALID_DATATYPE - Errors with this extended error code have the following properties:
#' dataType, fieldType}
#'      \item{SCREENFIELD_MULTISELECTCHOICE_SEMICOLON_NOT_SUPPORTED - Errors with this extended error code have the following properties:
#' choiceName}
#'      \item{SCREENFIELD_OUTPUTS_NOT_SUPPORTED - Errors with this extended error code have the following properties:
#' elementName, fieldType}
#'      \item{SCREENFIELD_TYPE_NOT_SUPPORTED - Errors with this extended error code have the following properties:
#' elementName, fieldType}
#'      \item{SCREENFIELD_USERINPUT_NOT_SUPPORTED_FOR_CHOICETYPE - Errors with this extended error code have the following properties:
#' choiceName}
#'      \item{SCREENFIELD_VALIDATIONRULE_NOT_SUPPORTED - Errors with this extended error code have the following properties:
#' elementName}
#'      \item{SCREENRULE_ACTION_INVALID_ATTRIBUTE - Errors with this extended error code have the following properties:
#' screenRuleName, attributeName}
#'      \item{SCREENRULE_ACTION_INVALID_ATTRIBUTE_FOR_API_VERSION - Errors with this extended error code have the following properties:
#' screenRuleName, attributeName}
#'      \item{SCREENRULE_ACTION_INVALID_VALUE - Errors with this extended error code have the following properties:
#' screenRuleName, acceptedValues, actionValue}
#'      \item{SCREENRULE_ACTION_MISSING_ATTRIBUTE - Errors with this extended error code have the following properties:
#' screenRuleName}
#'      \item{SCREENRULE_ACTION_MISSING_FIELDREFERENCE - Errors with this extended error code have the following properties:
#' screenRuleName}
#'      \item{SCREENRULE_ACTION_MISSING_VALUE - Errors with this extended error code have the following properties:
#' screenRuleName}
#'      \item{SCREENRULE_ATTRIBUTE_NOT_SUPPORTED_FOR_SCREENFIELD - Errors with this extended error code have the following properties:
#' screenRuleName, attributeName, fieldName}
#'      \item{SCREENRULE_FIELD_NOT_FOUND_ON_SCREEN - Errors with this extended error code have the following properties:
#' screenRuleName, fieldValue}
#'      \item{SCREENRULE_MISSING_ACTION - Errors with this extended error code have the following properties:
#' screenRuleName}
#'      \item{SCREENRULE_NOT_SUPPORTED_IN_ORG - Errors with this extended error code have the following properties:}
#'      \item{SCREENRULE_SCREENFIELD_NOT_VISIBLE - Errors with this extended error code have the following properties:
#' fieldName}
#'      \item{SCREENRULE_VISIBILITY_NOT_SUPPORTED_IN_ORG - Errors with this extended error code have the following properties:}
#'      \item{SCREEN_ALLOWBACK_ALLOWFINISH_BOTH_FALSE - Errors with this extended error code have the following properties:}
#'      \item{SCREEN_CONTAINS_LIGHTNING_COMPONENT - Errors with this extended error code have the following properties:
#' elementName}
#'      \item{SCREEN_MISSING_FOOTER_AND_LIGHTNING_COMPONENT - Errors with this extended error code have the following properties:}
#'      \item{SCREEN_MISSING_LABEL - Errors with this extended error code have the following properties:
#' characterLimit}
#'      \item{SCREEN_MULTISELECTFIELD_DOESNT_SUPPORT_CHOICE_WITH_USERINPUT - Errors with this extended error code have the following properties:
#' choiceName}
#'      \item{SCREEN_PAUSEDTEXT_NOT_SHOWN_WHEN_ALLOWPAUSE_IS_FALSE - Errors with this extended error code have the following properties:
#' fieldName}
#'      \item{SETTING_FIELD_MAKES_OTHER_FIELD_REQUIRED - Errors with this extended error code have the following properties:
#' fieldName, requiredField}
#'      \item{SETTING_FIELD_MAKES_OTHER_FIELD_UNSUPPORTED - Errors with this extended error code have the following properties:
#' fieldName, otherFieldName}
#'      \item{SOBJECT_ELEMENT_INCOMPATIBLE_DATATYPE - Errors with this extended error code have the following properties:
#' fieldName, fieldValue}
#'      \item{SOBJECT_ELEMENT_MISMATCHED_OBJECTTYPE - Errors with this extended error code have the following properties:
#' objectType, sobjectName}
#'      \item{SORT_ENCRYPTED_FIELDS_NOT_SUPPORTED - Errors with this extended error code have the following properties:
#' fieldName, objectType}
#'      \item{SORT_FIELD_MISSING - Errors with this extended error code have the following properties:
#' sortOrder}
#'      \item{SORT_FIELD_NOT_SUPPORTED - Errors with this extended error code have the following properties:
#' fieldName, objectName}
#'      \item{SORT_GEOLOCATION_FIELDS_NOT_SUPPORTED - Errors with this extended error code have the following properties:
#' fieldName, objectName}
#'      \item{SORT_LIMIT_INVALID - Errors with this extended error code have the following properties: maxLimit}
#'      \item{SORT_ORDER_MISSING - Errors with this extended error code have the following properties:
#' fieldName}
#'      \item{SPECIFIC_FIELD_VALUE_MAKES_OTHER_FIELD_REQUIRED - Errors with this extended error code have the following properties:
#' fieldName, fieldType, requiredField}
#'      \item{START_ELEMENT_MISSING - Errors with this extended error code have the following properties:}
#'      \item{SUBFLOW_DESKTOP_DESIGNER_FLOWS_NOT_SUPPORTED - Errors with this extended error code have the following properties: flowName}
#'      \item{SUBFLOW_INPUT_ELEMENT_INCOMPATIBLE_DATATYPES - Errors with this extended error code have the following properties:
#' subflowName, inputAssignmentNames}
#'      \item{SUBFLOW_INPUT_INVALID_VALUE - Errors with this extended error code have the following properties:
#' subflowName, inputAssignmentNames}
#'      \item{SUBFLOW_INPUT_MISMATCHED_COLLECTIONTYPES - Errors with this extended error code have the following properties:
#' subflowName, inputParameterNames}
#'      \item{SUBFLOW_INPUT_MISMATCHED_OBJECTS - Errors with this extended error code have the following properties:
#' subflowName, inputParameterNames}
#'      \item{SUBFLOW_INPUT_MISSING_NAME - Errors with this extended error code have the following properties:
#' subflowName}
#'      \item{SUBFLOW_INPUT_MULTIPLE_ASSIGNMENTS_TO_ONE_VARIABLE - Errors with this extended error code have the following properties:
#' inputVariableName}
#'      \item{SUBFLOW_INPUT_REFERENCES_FIELD_ON_SOBJECT_VARIABLE - Errors with this extended error code have the following properties:
#' inputVariableName}
#'      \item{SUBFLOW_INPUT_VALUE_INCOMPATIBLE_DATATYPES - Errors with this extended error code have the following properties:
#' subflowName, inputAssignmentNames}
#'      \item{SUBFLOW_INPUT_VARIABLE_NOT_FOUND_IN_MASTERFLOW - Errors with this extended error code have the following properties:
#' subflowName, inputAssignmentNames}
#'      \item{SUBFLOW_INPUT_VARIABLE_NOT_FOUND_IN_REFERENCEDFLOW - Errors with this extended error code have the following properties:
#' subflowName, inputAssignmentNames}
#'      \item{SUBFLOW_INPUT_VARIABLE_NO_INPUT_ACCESS - Errors with this extended error code have the following properties:
#' subflowName, inputAssignmentNames}
#'      \item{SUBFLOW_INVALID_NAME - Errors with this extended error code have the following properties:}
#'      \item{SUBFLOW_INVALID_REFERENCE - Errors with this extended error code have the following properties: flowName}
#'      \item{SUBFLOW_MASTER_FLOW_TYPE_NOT_AUTOLAUNCHED - Errors with this extended error code have the following properties:
#' parentFlowName}
#'      \item{SUBFLOW_MISSING_NAME - Errors with this extended error code have the following properties:}
#'      \item{SUBFLOW_NO_ACTIVE_VERSION - Errors with this extended error code have the following properties:
#' subflowName, flowName}
#'      \item{SUBFLOW_OUTPUT_INCOMPATIBLE_DATATYPES - Errors with this extended error code have the following properties:
#' subflowName, flowVersion, outputParameterNames}
#'      \item{SUBFLOW_OUTPUT_MISMATCHED_COLLECTIONTYPES - Errors with this extended error code have the following properties:
#' subflowName, flowVersion, outputParameterNames}
#'      \item{SUBFLOW_OUTPUT_MISMATCHED_OBJECTS - Errors with this extended error code have the following properties:
#' subflowName, flowVersion, outputParameterNames}
#'      \item{SUBFLOW_OUTPUT_MISSING_ASSIGNTOREFERENCE - Errors with this extended error code have the following properties:
#' outputAssignment}
#'      \item{SUBFLOW_OUTPUT_MISSING_NAME - Errors with this extended error code have the following properties:
#' subflowName}
#'      \item{SUBFLOW_OUTPUT_MULTIPLE_ASSIGNMENTS_TO_ONE_VARIABLE - Errors with this extended error code have the following properties:
#' outputVariableName}
#'      \item{SUBFLOW_OUTPUT_REFERENCES_FIELD_ON_SOBJECT_VARIABLE - Errors with this extended error code have the following properties:
#' outputAssignment}
#'      \item{SUBFLOW_OUTPUT_TARGET_DOES_NOT_EXIST_IN_MASTER_FLOW - Errors with this extended error code have the following properties:
#' subflowName, outputAssignmentName}
#'      \item{SUBFLOW_OUTPUT_VARIABLE_NOT_FOUND_IN_MASTERFLOW - Errors with this extended error code have the following properties:
#' subflowName, variableName}
#'      \item{SUBFLOW_OUTPUT_VARIABLE_NOT_FOUND_IN_REFERENCEDFLOW - Errors with this extended error code have the following properties:
#' subflowName, flowVersion, outputParameterNames}
#'      \item{SUBFLOW_OUTPUT_VARIABLE_NO_OUTPUT_ACCESS - Errors with this extended error code have the following properties:
#' subflowName, variableName}
#'      \item{SUBFLOW_REFERENCES_MASTERFLOW - Errors with this extended error code have the following properties:}
#'      \item{SURVEY_CHOICE_NOT_REFERENCED_BY_A_QUESTION - Errors with this extended error code have the following properties:
#' choiceName}
#'      \item{SURVEY_CHOICE_REFERENCED_BY_MULTIPLE_QUESTIONS - Errors with this extended error code have the following properties:
#' choiceName}
#'      \item{SURVEY_INACTIVE_SUBFLOWS - Errors with this extended error code have the following properties:
#' subflowName}
#'      \item{SURVEY_MISSING_QUESTION_OR_SUBFLOW - Errors with this extended error code have the following properties:
#' surveyName}
#'      \item{SURVEY_MISSING_REQUIRED_VARIABLES - Errors with this extended error code have the following properties:
#' surveyName}
#'      \item{SURVEY_NESTED_SUBFLOWS - Errors with this extended error code have the following properties:
#' subflowName}
#'      \item{SURVEY_NONSURVEY_SUBFLOWS - Errors with this extended error code have the following properties:
#' subflowName}
#'      \item{SURVEY_SCREENFIELD_TYPE_NOT_SUPPORTED_FOR_QUESTION - Errors with this extended error code have the following properties:
#' elementName}
#'      \item{SURVEY_START_ELEMENT_INVALID - Errors with this extended error code have the following properties:}
#'      \item{SURVEY_VARIABLE_ACCESS_INVALID - Errors with this extended error code have the following properties:
#' surveyName}
#'      \item{UNEXPECTED_ERROR - Errors with this extended error code have the following properties:}
#'      \item{VALUE_CHAR_LIMIT_EXCEEDED - Errors with this extended error code have the following properties:
#' elementName, characterLimit}
#'      \item{VARIABLE_FIELD_NOT_SUPPORTED_FOR_DATATYPE - Errors with this extended error code have the following properties:
#' fieldName, datatype}
#'      \item{VARIABLE_FIELD_NOT_SUPPORTED_FOR_DATATYPE_AND_COLLECTION - Errors with this extended error code have the following properties:
#' fieldName, datatype}
#'      \item{VARIABLE_FIELD_REQUIRED_FOR_DATATYPE - Errors with this extended error code have the following properties:
#' datatype, fieldName}
#'      \item{VARIABLE_SCALE_EXCEEDS_LIMIT - Errors with this extended error code have the following properties:
#' elementName}
#'      \item{VARIABLE_SCALE_NEGATIVE_INTEGER - Errors with this extended error code have the following properties:
#' elementName}
#'      \item{VARIABLE_SCALE_NULL - Errors with this extended error code have the following properties:
#' elementName}
#'      \item{WAITEVENT_DEFAULT_CONNECTOR_MISSING_LABEL - Errors with this extended error code have the following properties:
#' waitEventName}
#'      \item{WAITEVENT_DUPLICATE_INPUT_PARAM - Errors with this extended error code have the following properties:
#' parameterName}
#'      \item{WAITEVENT_INPUT_NOT_SUPPORTED_FOR_EVENTTYPE - Errors with this extended error code have the following properties:
#' waitEventName, inputParameterName}
#'      \item{WAITEVENT_INPUT_REQUIRES_LITERAL_VALUE - Errors with this extended error code have the following properties:
#' waitEventName, parameterName}
#'      \item{WAITEVENT_INVALID_CONDITION_LOGIC - Errors with this extended error code have the following properties:
#' waitEventName}
#'      \item{WAITEVENT_MISSING - Errors with this extended error code have the following properties:}
#'      \item{WAITEVENT_MISSING_CONNECTOR - Errors with this extended error code have the following properties:
#' waitEventName}
#'      \item{WAITEVENT_MISSING_EVENTTYPE - Errors with this extended error code have the following properties:
#' waitEventName}
#'      \item{WAITEVENT_OBJECT_NOT_SUPPORTED_FOR_EVENTTYPE - Errors with this extended error code have the following properties:
#' waitEventName}
#'      \item{WAITEVENT_OUTPUT_NOT_SUPPORTED_FOR_EVENTTYPE - Errors with this extended error code have the following properties:
#' waitEventName, outputParameter}
#'      \item{WAITEVENT_RELATIVEALARM_INVALID_DATETIME_FIELD - Errors with this extended error code have the following properties:
#' waitEventName, eventParameterName, incompatibleValue}
#'      \item{WAITEVENT_RELATIVEALARM_INVALID_FIELD - Errors with this extended error code have the following properties:
#' waitEventName, eventParameterName, incompatibleValue}
#'      \item{WAITEVENT_RELATIVEALARM_INVALID_OBJECTTYPE - Errors with this extended error code have the following properties:
#' waitEventName, inputParameterName}
#'      \item{WAITEVENT_RELATIVEALARM_INVALID_OFFSETNUMBER - Errors with this extended error code have the following properties:
#' waitEventName, eventParameterName, incompatibleValue}
#'      \item{WAITEVENT_RELATIVEALARM_INVALID_OFFSETUNIT - Errors with this extended error code have the following properties:
#' waitEventName, eventParameterName, incompatibleValue}
#'      \item{WAITEVENT_REQUIRED_INPUT_MISSING - Errors with this extended error code have the following properties:
#' waitEventName, parameterName}
#'      \item{WAITEVENT_TYPE_INVALID_OR_NOT_SUPPORTED - Errors with this extended error code have the following properties:
#' waitEventName}
#'      \item{WORKFLOW_MISSING_PROCESSMETADATAVALUES - Errors with this extended error code have the following properties: flowName}
#'      \item{WORKFLOW_OBJECTTYPE_NOT_FOUND - Errors with this extended error code have the following properties:
#' objectType}
#'      \item{WORKFLOW_OBJECTTYPE_NOT_SUPPORTED - Errors with this extended error code have the following properties:
#' objectType}
#'      \item{WORKFLOW_OBJECTVARIABLE_AND_OLDOBJECTVARIABLE_REFERENCE_SAME_SOBJECT_VARIABLE - Errors with this extended error code have the following properties:
#' objectVariableName, oldObjectVariableName}
#'      \item{WORKFLOW_OBJECTVARIABLE_DOESNT_SUPPORT_INPUT - Errors with this extended error code have the following properties:
#' objectType, objectVariableName}
#'      \item{WORKFLOW_OLDOBJECTVARIABLE_DOESNT_SUPPORT_INPUT - Errors with this extended error code have the following properties:
#' objectType, oldObjectVariableName}
#'      \item{WORKFLOW_PROCESSMETADATAVALUES_MORE_THAN_ONE_NAME - Errors with this extended error code have the following properties:
#' metadataValue}
#'      \item{WORKFLOW_PROCESS_METADATAVALUES_MISSING_NAME - Errors with this extended error code have the following properties:
#' metadataValue}
#'      \item{WORKFLOW_RECURSIVECOUNTVARIABLE_DOESNT_SUPPORT_INPUT - Errors with this extended error code have the following properties:
#' elementName}
#'      \item{WORKFLOW_TRIGGERTYPE_INVALID_VALUE - Errors with this extended error code have the following properties:}
#'    }
#'   }
#' }
#'
#' \strong{ExternalDataSource}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{authProvider}{a character}
#'  \item{certificate}{a character}
#'  \item{customConfiguration}{a character}
#'  \item{endpoint}{a character}
#'  \item{isWritable}{a character either 'true' or 'false'}
#'  \item{label}{a character}
#'  \item{oauthRefreshToken}{a character}
#'  \item{oauthScope}{a character}
#'  \item{oauthToken}{a character}
#'  \item{password}{a character}
#'  \item{principalType}{a ExternalPrincipalType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Anonymous}
#'      \item{PerUser}
#'      \item{NamedUser}
#'    }
#'   }
#'  \item{protocol}{a AuthenticationProtocol - which is a character taking one of the following values:
#'    \itemize{
#'      \item{NoAuthentication}
#'      \item{Oauth}
#'      \item{Password}
#'    }
#'   }
#'  \item{repository}{a character}
#'  \item{type}{a ExternalDataSourceType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Datacloud}
#'      \item{Datajourney}
#'      \item{OpenSearch}
#'      \item{Identity}
#'      \item{outgoingemail}
#'      \item{recommendation}
#'      \item{SfdcOrg}
#'      \item{OData}
#'      \item{OData4}
#'      \item{SimpleURL}
#'      \item{Wrapper}
#'    }
#'   }
#'  \item{username}{a character}
#'  \item{version}{a character}
#' }
#'
#' \strong{ExternalServiceRegistration}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{description}{a character}
#'  \item{label}{a character}
#'  \item{namedCredential}{a character}
#'  \item{schema}{a character}
#'  \item{schemaType}{a character}
#'  \item{schemaUrl}{a character}
#'  \item{status}{a character}
#' }
#'
#' \strong{FeedFilterCriterion}
#'
#' \describe{
#'  \item{feedItemType}{a FeedItemType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{TrackedChange}
#'      \item{UserStatus}
#'      \item{TextPost}
#'      \item{AdvancedTextPost}
#'      \item{LinkPost}
#'      \item{ContentPost}
#'      \item{PollPost}
#'      \item{RypplePost}
#'      \item{ProfileSkillPost}
#'      \item{DashboardComponentSnapshot}
#'      \item{ApprovalPost}
#'      \item{CaseCommentPost}
#'      \item{ReplyPost}
#'      \item{EmailMessageEvent}
#'      \item{CallLogPost}
#'      \item{ChangeStatusPost}
#'      \item{AttachArticleEvent}
#'      \item{MilestoneEvent}
#'      \item{ActivityEvent}
#'      \item{ChatTranscriptPost}
#'      \item{CollaborationGroupCreated}
#'      \item{CollaborationGroupUnarchived}
#'      \item{SocialPost}
#'      \item{QuestionPost}
#'      \item{FacebookPost}
#'      \item{BasicTemplateFeedItem}
#'      \item{CreateRecordEvent}
#'      \item{CanvasPost}
#'      \item{AnnouncementPost}
#'    }
#'   }
#'  \item{feedItemVisibility}{a FeedItemVisibility - which is a character taking one of the following values:
#'    \itemize{
#'      \item{AllUsers}
#'      \item{InternalUsers}
#'    }
#'   }
#'  \item{relatedSObjectType}{a character}
#' }
#'
#' \strong{FeedItemSettings}
#'
#' \describe{
#'  \item{characterLimit}{an integer}
#'  \item{collapseThread}{a character either 'true' or 'false'}
#'  \item{displayFormat}{a FeedItemDisplayFormat - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Default}
#'      \item{HideBlankLines}
#'    }
#'   }
#'  \item{feedItemType}{a FeedItemType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{TrackedChange}
#'      \item{UserStatus}
#'      \item{TextPost}
#'      \item{AdvancedTextPost}
#'      \item{LinkPost}
#'      \item{ContentPost}
#'      \item{PollPost}
#'      \item{RypplePost}
#'      \item{ProfileSkillPost}
#'      \item{DashboardComponentSnapshot}
#'      \item{ApprovalPost}
#'      \item{CaseCommentPost}
#'      \item{ReplyPost}
#'      \item{EmailMessageEvent}
#'      \item{CallLogPost}
#'      \item{ChangeStatusPost}
#'      \item{AttachArticleEvent}
#'      \item{MilestoneEvent}
#'      \item{ActivityEvent}
#'      \item{ChatTranscriptPost}
#'      \item{CollaborationGroupCreated}
#'      \item{CollaborationGroupUnarchived}
#'      \item{SocialPost}
#'      \item{QuestionPost}
#'      \item{FacebookPost}
#'      \item{BasicTemplateFeedItem}
#'      \item{CreateRecordEvent}
#'      \item{CanvasPost}
#'      \item{AnnouncementPost}
#'    }
#'   }
#' }
#'
#' \strong{FeedLayout}
#'
#' \describe{
#'  \item{autocollapsePublisher}{a character either 'true' or 'false'}
#'  \item{compactFeed}{a character either 'true' or 'false'}
#'  \item{feedFilterPosition}{a FeedLayoutFilterPosition - which is a character taking one of the following values:
#'    \itemize{
#'      \item{CenterDropDown}
#'      \item{LeftFixed}
#'      \item{LeftFloat}
#'    }
#'   }
#'  \item{feedFilters}{a FeedLayoutFilter}
#'  \item{fullWidthFeed}{a character either 'true' or 'false'}
#'  \item{hideSidebar}{a character either 'true' or 'false'}
#'  \item{highlightExternalFeedItems}{a character either 'true' or 'false'}
#'  \item{leftComponents}{a FeedLayoutComponent}
#'  \item{rightComponents}{a FeedLayoutComponent}
#'  \item{useInlineFiltersInConsole}{a character either 'true' or 'false'}
#' }
#'
#' \strong{FeedLayoutComponent}
#'
#' \describe{
#'  \item{componentType}{a FeedLayoutComponentType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{HelpAndToolLinks}
#'      \item{CustomButtons}
#'      \item{Following}
#'      \item{Followers}
#'      \item{CustomLinks}
#'      \item{Milestones}
#'      \item{Topics}
#'      \item{CaseUnifiedFiles}
#'      \item{Visualforce}
#'    }
#'   }
#'  \item{height}{an integer}
#'  \item{page}{a character}
#' }
#'
#' \strong{FeedLayoutFilter}
#'
#' \describe{
#'  \item{feedFilterName}{a character}
#'  \item{feedFilterType}{a FeedLayoutFilterType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{AllUpdates}
#'      \item{FeedItemType}
#'      \item{Custom}
#'    }
#'   }
#'  \item{feedItemType}{a FeedItemType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{TrackedChange}
#'      \item{UserStatus}
#'      \item{TextPost}
#'      \item{AdvancedTextPost}
#'      \item{LinkPost}
#'      \item{ContentPost}
#'      \item{PollPost}
#'      \item{RypplePost}
#'      \item{ProfileSkillPost}
#'      \item{DashboardComponentSnapshot}
#'      \item{ApprovalPost}
#'      \item{CaseCommentPost}
#'      \item{ReplyPost}
#'      \item{EmailMessageEvent}
#'      \item{CallLogPost}
#'      \item{ChangeStatusPost}
#'      \item{AttachArticleEvent}
#'      \item{MilestoneEvent}
#'      \item{ActivityEvent}
#'      \item{ChatTranscriptPost}
#'      \item{CollaborationGroupCreated}
#'      \item{CollaborationGroupUnarchived}
#'      \item{SocialPost}
#'      \item{QuestionPost}
#'      \item{FacebookPost}
#'      \item{BasicTemplateFeedItem}
#'      \item{CreateRecordEvent}
#'      \item{CanvasPost}
#'      \item{AnnouncementPost}
#'    }
#'   }
#' }
#'
#' \strong{FieldMapping}
#'
#' \describe{
#'  \item{SObjectType}{a character}
#'  \item{developerName}{a character}
#'  \item{fieldMappingRows}{a FieldMappingRow}
#'  \item{masterLabel}{a character}
#' }
#'
#' \strong{FieldMappingField}
#'
#' \describe{
#'  \item{dataServiceField}{a character}
#'  \item{dataServiceObjectName}{a character}
#'  \item{priority}{an integer}
#' }
#'
#' \strong{FieldMappingRow}
#'
#' \describe{
#'  \item{SObjectType}{a character}
#'  \item{fieldMappingFields}{a FieldMappingField}
#'  \item{fieldName}{a character}
#'  \item{mappingOperation}{a MappingOperation - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Autofill}
#'      \item{Overwrite}
#'    }
#'   }
#' }
#'
#' \strong{FieldOverride}
#'
#' \describe{
#'  \item{field}{a character}
#'  \item{formula}{a character}
#'  \item{literalValue}{a character}
#' }
#'
#' \strong{FieldServiceSettings}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{fieldServiceNotificationsOrgPref}{a character either 'true' or 'false'}
#'  \item{fieldServiceOrgPref}{a character either 'true' or 'false'}
#'  \item{serviceAppointmentsDueDateOffsetOrgValue}{an integer}
#'  \item{workOrderLineItemSearchFields}{a character}
#'  \item{workOrderSearchFields}{a character}
#' }
#'
#' \strong{FieldSet}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{availableFields}{a FieldSetItem}
#'  \item{description}{a character}
#'  \item{displayedFields}{a FieldSetItem}
#'  \item{label}{a character}
#' }
#'
#' \strong{FieldSetItem}
#'
#' \describe{
#'  \item{field}{a character}
#'  \item{isFieldManaged}{a character either 'true' or 'false'}
#'  \item{isRequired}{a character either 'true' or 'false'}
#' }
#'
#' \strong{FieldSetTranslation}
#'
#' \describe{
#'  \item{label}{a character}
#'  \item{name}{a character}
#' }
#'
#' \strong{FieldValue}
#'
#' \describe{
#'  \item{name}{a character}
#'  \item{value}{a character that appears similar to any of the other accepted types (integer, numeric, date, datetime, boolean)}
#' }
#'
#' \strong{FileProperties}
#'
#' \describe{
#'  \item{createdById}{a character}
#'  \item{createdByName}{a character}
#'  \item{createdDate}{a character formatted as 'yyyy-mm-ddThh:mm:ssZ'}
#'  \item{fileName}{a character}
#'  \item{fullName}{a character}
#'  \item{id}{a character}
#'  \item{lastModifiedById}{a character}
#'  \item{lastModifiedByName}{a character}
#'  \item{lastModifiedDate}{a character formatted as 'yyyy-mm-ddThh:mm:ssZ'}
#'  \item{manageableState}{a ManageableState - which is a character taking one of the following values:
#'    \itemize{
#'      \item{released}
#'      \item{deleted}
#'      \item{deprecated}
#'      \item{installed}
#'      \item{beta}
#'      \item{unmanaged}
#'    }
#'   }
#'  \item{namespacePrefix}{a character}
#'  \item{type}{a character}
#' }
#'
#' \strong{FileTypeDispositionAssignmentBean}
#'
#' \describe{
#'  \item{behavior}{a FileDownloadBehavior - which is a character taking one of the following values:
#'    \itemize{
#'      \item{DOWNLOAD}
#'      \item{EXECUTE_IN_BROWSER}
#'      \item{HYBRID}
#'    }
#'   }
#'  \item{fileType}{a FileType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{UNKNOWN}
#'      \item{PDF}
#'      \item{POWER_POINT}
#'      \item{POWER_POINT_X}
#'      \item{POWER_POINT_M}
#'      \item{POWER_POINT_T}
#'      \item{WORD}
#'      \item{WORD_X}
#'      \item{WORD_M}
#'      \item{WORD_T}
#'      \item{PPS}
#'      \item{PPSX}
#'      \item{EXCEL}
#'      \item{EXCEL_X}
#'      \item{EXCEL_M}
#'      \item{EXCEL_T}
#'      \item{GOOGLE_DOCUMENT}
#'      \item{GOOGLE_PRESENTATION}
#'      \item{GOOGLE_SPREADSHEET}
#'      \item{GOOGLE_DRAWING}
#'      \item{GOOGLE_FORM}
#'      \item{GOOGLE_SCRIPT}
#'      \item{LINK}
#'      \item{SLIDE}
#'      \item{AAC}
#'      \item{ACGI}
#'      \item{AI}
#'      \item{AVI}
#'      \item{BMP}
#'      \item{BOXNOTE}
#'      \item{CSV}
#'      \item{EPS}
#'      \item{EXE}
#'      \item{FLASH}
#'      \item{GIF}
#'      \item{GZIP}
#'      \item{HTM}
#'      \item{HTML}
#'      \item{HTX}
#'      \item{JPEG}
#'      \item{JPE}
#'      \item{PJP}
#'      \item{PJPEG}
#'      \item{JFIF}
#'      \item{JPG}
#'      \item{JS}
#'      \item{MHTM}
#'      \item{MHTML}
#'      \item{MP3}
#'      \item{M4A}
#'      \item{M4V}
#'      \item{MP4}
#'      \item{MPEG}
#'      \item{MPG}
#'      \item{MOV}
#'      \item{MSG}
#'      \item{ODP}
#'      \item{ODS}
#'      \item{ODT}
#'      \item{OGV}
#'      \item{PNG}
#'      \item{PSD}
#'      \item{RTF}
#'      \item{QUIPDOC}
#'      \item{QUIPSHEET}
#'      \item{SHTM}
#'      \item{SHTML}
#'      \item{SNOTE}
#'      \item{STYPI}
#'      \item{SVG}
#'      \item{SVGZ}
#'      \item{TEXT}
#'      \item{THTML}
#'      \item{VISIO}
#'      \item{WMV}
#'      \item{WRF}
#'      \item{XML}
#'      \item{ZIP}
#'      \item{XZIP}
#'      \item{WMA}
#'      \item{XSN}
#'      \item{TRTF}
#'      \item{TXML}
#'      \item{WEBVIEW}
#'      \item{RFC822}
#'      \item{ASF}
#'      \item{DWG}
#'      \item{JAR}
#'      \item{XJS}
#'      \item{OPX}
#'      \item{XPSD}
#'      \item{TIF}
#'      \item{TIFF}
#'      \item{WAV}
#'      \item{CSS}
#'      \item{THUMB720BY480}
#'      \item{THUMB240BY180}
#'      \item{THUMB120BY90}
#'      \item{ALLTHUMBS}
#'      \item{PAGED_FLASH}
#'      \item{PACK}
#'      \item{C}
#'      \item{CPP}
#'      \item{WORDT}
#'      \item{INI}
#'      \item{JAVA}
#'      \item{LOG}
#'      \item{POWER_POINTT}
#'      \item{SQL}
#'      \item{XHTML}
#'      \item{EXCELT}
#'    }
#'   }
#'  \item{securityRiskFileType}{a character either 'true' or 'false'}
#' }
#'
#' \strong{FileUploadAndDownloadSecuritySettings}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{dispositions}{a FileTypeDispositionAssignmentBean}
#'  \item{noHtmlUploadAsAttachment}{a character either 'true' or 'false'}
#' }
#'
#' \strong{FilterItem}
#'
#' \describe{
#'  \item{field}{a character}
#'  \item{operation}{a FilterOperation - which is a character taking one of the following values:
#'    \itemize{
#'      \item{equals}
#'      \item{notEqual}
#'      \item{lessThan}
#'      \item{greaterThan}
#'      \item{lessOrEqual}
#'      \item{greaterOrEqual}
#'      \item{contains}
#'      \item{notContain}
#'      \item{startsWith}
#'      \item{includes}
#'      \item{excludes}
#'      \item{within}
#'    }
#'   }
#'  \item{value}{a character}
#'  \item{valueField}{a character}
#' }
#'
#' \strong{FindSimilarOppFilter}
#'
#' \describe{
#'  \item{similarOpportunitiesDisplayColumns}{a character}
#'  \item{similarOpportunitiesMatchFields}{a character}
#' }
#'
#' \strong{FiscalYearSettings}
#'
#' \describe{
#'  \item{fiscalYearNameBasedOn}{a character}
#'  \item{startMonth}{a character}
#' }
#'
#' \strong{FlexiPage}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{description}{a character}
#'  \item{flexiPageRegions}{a FlexiPageRegion}
#'  \item{masterLabel}{a character}
#'  \item{parentFlexiPage}{a character}
#'  \item{platformActionlist}{a PlatformActionList}
#'  \item{quickActionList}{a QuickActionList}
#'  \item{sobjectType}{a character}
#'  \item{template}{a FlexiPageTemplateInstance}
#'  \item{type}{a FlexiPageType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{AppPage}
#'      \item{ObjectPage}
#'      \item{RecordPage}
#'      \item{HomePage}
#'      \item{MailAppAppPage}
#'      \item{CommAppPage}
#'      \item{CommForgotPasswordPage}
#'      \item{CommLoginPage}
#'      \item{CommObjectPage}
#'      \item{CommQuickActionCreatePage}
#'      \item{CommRecordPage}
#'      \item{CommRelatedListPage}
#'      \item{CommSearchResultPage}
#'      \item{CommGlobalSearchResultPage}
#'      \item{CommSelfRegisterPage}
#'      \item{CommThemeLayoutPage}
#'      \item{UtilityBar}
#'      \item{RecordPreview}
#'    }
#'   }
#' }
#'
#' \strong{FlexiPageRegion}
#'
#' \describe{
#'  \item{appendable}{a RegionFlagStatus - which is a character taking one of the following values:
#'    \itemize{
#'      \item{disabled}
#'      \item{enabled}
#'    }
#'   }
#'  \item{componentInstances}{a ComponentInstance}
#'  \item{mode}{a FlexiPageRegionMode - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Append}
#'      \item{Prepend}
#'      \item{Replace}
#'    }
#'   }
#'  \item{name}{a character}
#'  \item{prependable}{a RegionFlagStatus - which is a character taking one of the following values:
#'    \itemize{
#'      \item{disabled}
#'      \item{enabled}
#'    }
#'   }
#'  \item{replaceable}{a RegionFlagStatus - which is a character taking one of the following values:
#'    \itemize{
#'      \item{disabled}
#'      \item{enabled}
#'    }
#'   }
#'  \item{type}{a FlexiPageRegionType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Region}
#'      \item{Facet}
#'    }
#'   }
#' }
#'
#' \strong{FlexiPageTemplateInstance}
#'
#' \describe{
#'  \item{name}{a character}
#'  \item{properties}{a ComponentInstanceProperty}
#' }
#'
#' \strong{Flow}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{actionCalls}{a FlowActionCall}
#'  \item{apexPluginCalls}{a FlowApexPluginCall}
#'  \item{assignments}{a FlowAssignment}
#'  \item{choices}{a FlowChoice}
#'  \item{constants}{a FlowConstant}
#'  \item{decisions}{a FlowDecision}
#'  \item{description}{a character}
#'  \item{dynamicChoiceSets}{a FlowDynamicChoiceSet}
#'  \item{formulas}{a FlowFormula}
#'  \item{interviewLabel}{a character}
#'  \item{label}{a character}
#'  \item{loops}{a FlowLoop}
#'  \item{processMetadataValues}{a FlowMetadataValue}
#'  \item{processType}{a FlowProcessType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{AutoLaunchedFlow}
#'      \item{Flow}
#'      \item{Workflow}
#'      \item{CustomEvent}
#'      \item{InvocableProcess}
#'      \item{LoginFlow}
#'      \item{ActionPlan}
#'      \item{JourneyBuilderIntegration}
#'      \item{UserProvisioningFlow}
#'      \item{Survey}
#'      \item{FieldServiceMobile}
#'      \item{OrchestrationFlow}
#'      \item{FieldServiceWeb}
#'      \item{TransactionSecurityFlow}
#'    }
#'   }
#'  \item{recordCreates}{a FlowRecordCreate}
#'  \item{recordDeletes}{a FlowRecordDelete}
#'  \item{recordLookups}{a FlowRecordLookup}
#'  \item{recordUpdates}{a FlowRecordUpdate}
#'  \item{screens}{a FlowScreen}
#'  \item{stages}{a FlowStage}
#'  \item{startElementReference}{a character}
#'  \item{steps}{a FlowStep}
#'  \item{subflows}{a FlowSubflow}
#'  \item{textTemplates}{a FlowTextTemplate}
#'  \item{variables}{a FlowVariable}
#'  \item{waits}{a FlowWait}
#' }
#'
#' \strong{FlowActionCall}
#'
#' \describe{
#'  \item{label}{a character (inherited from FlowNode)}
#'  \item{locationX}{an integer (inherited from FlowNode)}
#'  \item{locationY}{an integer (inherited from FlowNode)}
#'  \item{actionName}{a character}
#'  \item{actionType}{a InvocableActionType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{apex}
#'      \item{chatterPost}
#'      \item{contentWorkspaceEnableFolders}
#'      \item{emailAlert}
#'      \item{emailSimple}
#'      \item{flow}
#'      \item{metricRefresh}
#'      \item{quickAction}
#'      \item{submit}
#'      \item{thanks}
#'      \item{thunderResponse}
#'      \item{createServiceReport}
#'      \item{deployOrchestration}
#'      \item{createResponseEventAction}
#'      \item{generateWorkOrders}
#'      \item{deactivateSessionPermSet}
#'      \item{activateSessionPermSet}
#'      \item{aggregateValue}
#'      \item{orchestrationTimer}
#'      \item{orchestrationDebugLog}
#'      \item{choosePricebook}
#'      \item{localAction}
#'    }
#'   }
#'  \item{connector}{a FlowConnector}
#'  \item{faultConnector}{a FlowConnector}
#'  \item{inputParameters}{a FlowActionCallInputParameter}
#'  \item{outputParameters}{a FlowActionCallOutputParameter}
#' }
#'
#' \strong{FlowActionCallInputParameter}
#'
#' \describe{
#'  \item{processMetadataValues}{a FlowMetadataValue (inherited from FlowBaseElement)}
#'  \item{name}{a character}
#'  \item{value}{a FlowElementReferenceOrValue}
#' }
#'
#' \strong{FlowActionCallOutputParameter}
#'
#' \describe{
#'  \item{processMetadataValues}{a FlowMetadataValue (inherited from FlowBaseElement)}
#'  \item{assignToReference}{a character}
#'  \item{name}{a character}
#' }
#'
#' \strong{FlowApexPluginCall}
#'
#' \describe{
#'  \item{label}{a character (inherited from FlowNode)}
#'  \item{locationX}{an integer (inherited from FlowNode)}
#'  \item{locationY}{an integer (inherited from FlowNode)}
#'  \item{apexClass}{a character}
#'  \item{connector}{a FlowConnector}
#'  \item{faultConnector}{a FlowConnector}
#'  \item{inputParameters}{a FlowApexPluginCallInputParameter}
#'  \item{outputParameters}{a FlowApexPluginCallOutputParameter}
#' }
#'
#' \strong{FlowApexPluginCallInputParameter}
#'
#' \describe{
#'  \item{processMetadataValues}{a FlowMetadataValue (inherited from FlowBaseElement)}
#'  \item{name}{a character}
#'  \item{value}{a FlowElementReferenceOrValue}
#' }
#'
#' \strong{FlowApexPluginCallOutputParameter}
#'
#' \describe{
#'  \item{processMetadataValues}{a FlowMetadataValue (inherited from FlowBaseElement)}
#'  \item{assignToReference}{a character}
#'  \item{name}{a character}
#' }
#'
#' \strong{FlowAssignment}
#'
#' \describe{
#'  \item{label}{a character (inherited from FlowNode)}
#'  \item{locationX}{an integer (inherited from FlowNode)}
#'  \item{locationY}{an integer (inherited from FlowNode)}
#'  \item{assignmentItems}{a FlowAssignmentItem}
#'  \item{connector}{a FlowConnector}
#' }
#'
#' \strong{FlowAssignmentItem}
#'
#' \describe{
#'  \item{processMetadataValues}{a FlowMetadataValue (inherited from FlowBaseElement)}
#'  \item{assignToReference}{a character}
#'  \item{operator}{a FlowAssignmentOperator - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Assign}
#'      \item{Add}
#'      \item{Subtract}
#'      \item{AddItem}
#'    }
#'   }
#'  \item{value}{a FlowElementReferenceOrValue}
#' }
#'
#' \strong{FlowBaseElement}
#'
#' \describe{
#'  \item{processMetadataValues}{a FlowMetadataValue}
#' }
#'
#' \strong{FlowCategory}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{description}{a character}
#'  \item{flowCategoryItems}{a FlowCategoryItems}
#'  \item{masterLabel}{a character}
#' }
#'
#' \strong{FlowCategoryItems}
#'
#' \describe{
#'  \item{flow}{a character}
#' }
#'
#' \strong{FlowChoice}
#'
#' \describe{
#'  \item{description}{a character (inherited from FlowElement)}
#'  \item{name}{a character (inherited from FlowElement)}
#'  \item{choiceText}{a character}
#'  \item{dataType}{a FlowDataType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Currency}
#'      \item{Date}
#'      \item{Number}
#'      \item{String}
#'      \item{Boolean}
#'      \item{SObject}
#'      \item{DateTime}
#'      \item{Picklist}
#'      \item{Multipicklist}
#'    }
#'   }
#'  \item{userInput}{a FlowChoiceUserInput}
#'  \item{value}{a FlowElementReferenceOrValue}
#' }
#'
#' \strong{FlowChoiceTranslation}
#'
#' \describe{
#'  \item{choiceText}{a character}
#'  \item{name}{a character}
#'  \item{userInput}{a FlowChoiceUserInputTranslation}
#' }
#'
#' \strong{FlowChoiceUserInput}
#'
#' \describe{
#'  \item{processMetadataValues}{a FlowMetadataValue (inherited from FlowBaseElement)}
#'  \item{isRequired}{a character either 'true' or 'false'}
#'  \item{promptText}{a character}
#'  \item{validationRule}{a FlowInputValidationRule}
#' }
#'
#' \strong{FlowChoiceUserInputTranslation}
#'
#' \describe{
#'  \item{promptText}{a character}
#'  \item{validationRule}{a FlowInputValidationRuleTranslation}
#' }
#'
#' \strong{FlowCondition}
#'
#' \describe{
#'  \item{processMetadataValues}{a FlowMetadataValue (inherited from FlowBaseElement)}
#'  \item{leftValueReference}{a character}
#'  \item{operator}{a FlowComparisonOperator - which is a character taking one of the following values:
#'    \itemize{
#'      \item{EqualTo}
#'      \item{NotEqualTo}
#'      \item{GreaterThan}
#'      \item{LessThan}
#'      \item{GreaterThanOrEqualTo}
#'      \item{LessThanOrEqualTo}
#'      \item{StartsWith}
#'      \item{EndsWith}
#'      \item{Contains}
#'      \item{IsNull}
#'      \item{WasSet}
#'      \item{WasSelected}
#'      \item{WasVisited}
#'    }
#'   }
#'  \item{rightValue}{a FlowElementReferenceOrValue}
#' }
#'
#' \strong{FlowConnector}
#'
#' \describe{
#'  \item{processMetadataValues}{a FlowMetadataValue (inherited from FlowBaseElement)}
#'  \item{targetReference}{a character}
#' }
#'
#' \strong{FlowConstant}
#'
#' \describe{
#'  \item{description}{a character (inherited from FlowElement)}
#'  \item{name}{a character (inherited from FlowElement)}
#'  \item{dataType}{a FlowDataType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Currency}
#'      \item{Date}
#'      \item{Number}
#'      \item{String}
#'      \item{Boolean}
#'      \item{SObject}
#'      \item{DateTime}
#'      \item{Picklist}
#'      \item{Multipicklist}
#'    }
#'   }
#'  \item{value}{a FlowElementReferenceOrValue}
#' }
#'
#' \strong{FlowDecision}
#'
#' \describe{
#'  \item{label}{a character (inherited from FlowNode)}
#'  \item{locationX}{an integer (inherited from FlowNode)}
#'  \item{locationY}{an integer (inherited from FlowNode)}
#'  \item{defaultConnector}{a FlowConnector}
#'  \item{defaultConnectorLabel}{a character}
#'  \item{rules}{a FlowRule}
#' }
#'
#' \strong{FlowDefinition}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{activeVersionNumber}{an integer}
#'  \item{description}{a character}
#'  \item{masterLabel}{a character}
#' }
#'
#' \strong{FlowDefinitionTranslation}
#'
#' \describe{
#'  \item{flows}{a FlowTranslation}
#'  \item{fullName}{a character}
#'  \item{label}{a character}
#' }
#'
#' \strong{FlowDynamicChoiceSet}
#'
#' \describe{
#'  \item{description}{a character (inherited from FlowElement)}
#'  \item{name}{a character (inherited from FlowElement)}
#'  \item{dataType}{a FlowDataType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Currency}
#'      \item{Date}
#'      \item{Number}
#'      \item{String}
#'      \item{Boolean}
#'      \item{SObject}
#'      \item{DateTime}
#'      \item{Picklist}
#'      \item{Multipicklist}
#'    }
#'   }
#'  \item{displayField}{a character}
#'  \item{filters}{a FlowRecordFilter}
#'  \item{limit}{an integer}
#'  \item{object}{a character}
#'  \item{outputAssignments}{a FlowOutputFieldAssignment}
#'  \item{picklistField}{a character}
#'  \item{picklistObject}{a character}
#'  \item{sortField}{a character}
#'  \item{sortOrder}{a SortOrder - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Asc}
#'      \item{Desc}
#'    }
#'   }
#'  \item{valueField}{a character}
#' }
#'
#' \strong{FlowElement}
#'
#' \describe{
#'  \item{processMetadataValues}{a FlowMetadataValue (inherited from FlowBaseElement)}
#'  \item{description}{a character}
#'  \item{name}{a character}
#' }
#'
#' \strong{FlowElementReferenceOrValue}
#'
#' \describe{
#'  \item{booleanValue}{a character either 'true' or 'false'}
#'  \item{dateTimeValue}{a character formatted as 'yyyy-mm-ddThh:mm:ssZ'}
#'  \item{dateValue}{a character formatted as 'yyyy-mm-dd'}
#'  \item{elementReference}{a character}
#'  \item{numberValue}{a numeric}
#'  \item{stringValue}{a character}
#' }
#'
#' \strong{FlowFormula}
#'
#' \describe{
#'  \item{description}{a character (inherited from FlowElement)}
#'  \item{name}{a character (inherited from FlowElement)}
#'  \item{dataType}{a FlowDataType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Currency}
#'      \item{Date}
#'      \item{Number}
#'      \item{String}
#'      \item{Boolean}
#'      \item{SObject}
#'      \item{DateTime}
#'      \item{Picklist}
#'      \item{Multipicklist}
#'    }
#'   }
#'  \item{expression}{a character}
#'  \item{scale}{an integer}
#' }
#'
#' \strong{FlowInputFieldAssignment}
#'
#' \describe{
#'  \item{processMetadataValues}{a FlowMetadataValue (inherited from FlowBaseElement)}
#'  \item{field}{a character}
#'  \item{value}{a FlowElementReferenceOrValue}
#' }
#'
#' \strong{FlowInputValidationRule}
#'
#' \describe{
#'  \item{errorMessage}{a character}
#'  \item{formulaExpression}{a character}
#' }
#'
#' \strong{FlowInputValidationRuleTranslation}
#'
#' \describe{
#'  \item{errorMessage}{a character}
#' }
#'
#' \strong{FlowLoop}
#'
#' \describe{
#'  \item{label}{a character (inherited from FlowNode)}
#'  \item{locationX}{an integer (inherited from FlowNode)}
#'  \item{locationY}{an integer (inherited from FlowNode)}
#'  \item{assignNextValueToReference}{a character}
#'  \item{collectionReference}{a character}
#'  \item{iterationOrder}{a IterationOrder - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Asc}
#'      \item{Desc}
#'    }
#'   }
#'  \item{nextValueConnector}{a FlowConnector}
#'  \item{noMoreValuesConnector}{a FlowConnector}
#' }
#'
#' \strong{FlowMetadataValue}
#'
#' \describe{
#'  \item{name}{a character}
#'  \item{value}{a FlowElementReferenceOrValue}
#' }
#'
#' \strong{FlowNode}
#'
#' \describe{
#'  \item{description}{a character (inherited from FlowElement)}
#'  \item{name}{a character (inherited from FlowElement)}
#'  \item{label}{a character}
#'  \item{locationX}{an integer}
#'  \item{locationY}{an integer}
#' }
#'
#' \strong{FlowOutputFieldAssignment}
#'
#' \describe{
#'  \item{processMetadataValues}{a FlowMetadataValue (inherited from FlowBaseElement)}
#'  \item{assignToReference}{a character}
#'  \item{field}{a character}
#' }
#'
#' \strong{FlowRecordCreate}
#'
#' \describe{
#'  \item{label}{a character (inherited from FlowNode)}
#'  \item{locationX}{an integer (inherited from FlowNode)}
#'  \item{locationY}{an integer (inherited from FlowNode)}
#'  \item{assignRecordIdToReference}{a character}
#'  \item{connector}{a FlowConnector}
#'  \item{faultConnector}{a FlowConnector}
#'  \item{inputAssignments}{a FlowInputFieldAssignment}
#'  \item{inputReference}{a character}
#'  \item{object}{a character}
#' }
#'
#' \strong{FlowRecordDelete}
#'
#' \describe{
#'  \item{label}{a character (inherited from FlowNode)}
#'  \item{locationX}{an integer (inherited from FlowNode)}
#'  \item{locationY}{an integer (inherited from FlowNode)}
#'  \item{connector}{a FlowConnector}
#'  \item{faultConnector}{a FlowConnector}
#'  \item{filters}{a FlowRecordFilter}
#'  \item{inputReference}{a character}
#'  \item{object}{a character}
#' }
#'
#' \strong{FlowRecordFilter}
#'
#' \describe{
#'  \item{processMetadataValues}{a FlowMetadataValue (inherited from FlowBaseElement)}
#'  \item{field}{a character}
#'  \item{operator}{a FlowRecordFilterOperator - which is a character taking one of the following values:
#'    \itemize{
#'      \item{EqualTo}
#'      \item{NotEqualTo}
#'      \item{GreaterThan}
#'      \item{LessThan}
#'      \item{GreaterThanOrEqualTo}
#'      \item{LessThanOrEqualTo}
#'      \item{StartsWith}
#'      \item{EndsWith}
#'      \item{Contains}
#'      \item{IsNull}
#'    }
#'   }
#'  \item{value}{a FlowElementReferenceOrValue}
#' }
#'
#' \strong{FlowRecordLookup}
#'
#' \describe{
#'  \item{label}{a character (inherited from FlowNode)}
#'  \item{locationX}{an integer (inherited from FlowNode)}
#'  \item{locationY}{an integer (inherited from FlowNode)}
#'  \item{assignNullValuesIfNoRecordsFound}{a character either 'true' or 'false'}
#'  \item{connector}{a FlowConnector}
#'  \item{faultConnector}{a FlowConnector}
#'  \item{filters}{a FlowRecordFilter}
#'  \item{object}{a character}
#'  \item{outputAssignments}{a FlowOutputFieldAssignment}
#'  \item{outputReference}{a character}
#'  \item{queriedFields}{a character}
#'  \item{sortField}{a character}
#'  \item{sortOrder}{a SortOrder - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Asc}
#'      \item{Desc}
#'    }
#'   }
#' }
#'
#' \strong{FlowRecordUpdate}
#'
#' \describe{
#'  \item{label}{a character (inherited from FlowNode)}
#'  \item{locationX}{an integer (inherited from FlowNode)}
#'  \item{locationY}{an integer (inherited from FlowNode)}
#'  \item{connector}{a FlowConnector}
#'  \item{faultConnector}{a FlowConnector}
#'  \item{filters}{a FlowRecordFilter}
#'  \item{inputAssignments}{a FlowInputFieldAssignment}
#'  \item{inputReference}{a character}
#'  \item{object}{a character}
#' }
#'
#' \strong{FlowRule}
#'
#' \describe{
#'  \item{description}{a character (inherited from FlowElement)}
#'  \item{name}{a character (inherited from FlowElement)}
#'  \item{conditionLogic}{a character}
#'  \item{conditions}{a FlowCondition}
#'  \item{connector}{a FlowConnector}
#'  \item{label}{a character}
#' }
#'
#' \strong{FlowScreen}
#'
#' \describe{
#'  \item{label}{a character (inherited from FlowNode)}
#'  \item{locationX}{an integer (inherited from FlowNode)}
#'  \item{locationY}{an integer (inherited from FlowNode)}
#'  \item{allowBack}{a character either 'true' or 'false'}
#'  \item{allowFinish}{a character either 'true' or 'false'}
#'  \item{allowPause}{a character either 'true' or 'false'}
#'  \item{connector}{a FlowConnector}
#'  \item{fields}{a FlowScreenField}
#'  \item{helpText}{a character}
#'  \item{pausedText}{a character}
#'  \item{rules}{a FlowScreenRule}
#'  \item{showFooter}{a character either 'true' or 'false'}
#'  \item{showHeader}{a character either 'true' or 'false'}
#' }
#'
#' \strong{FlowScreenField}
#'
#' \describe{
#'  \item{description}{a character (inherited from FlowElement)}
#'  \item{name}{a character (inherited from FlowElement)}
#'  \item{choiceReferences}{a character}
#'  \item{dataType}{a FlowDataType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Currency}
#'      \item{Date}
#'      \item{Number}
#'      \item{String}
#'      \item{Boolean}
#'      \item{SObject}
#'      \item{DateTime}
#'      \item{Picklist}
#'      \item{Multipicklist}
#'    }
#'   }
#'  \item{defaultSelectedChoiceReference}{a character}
#'  \item{defaultValue}{a FlowElementReferenceOrValue}
#'  \item{extensionName}{a character}
#'  \item{fieldText}{a character}
#'  \item{fieldType}{a FlowScreenFieldType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{DisplayText}
#'      \item{InputField}
#'      \item{LargeTextArea}
#'      \item{PasswordField}
#'      \item{RadioButtons}
#'      \item{DropdownBox}
#'      \item{MultiSelectCheckboxes}
#'      \item{MultiSelectPicklist}
#'      \item{ComponentInstance}
#'    }
#'   }
#'  \item{helpText}{a character}
#'  \item{inputParameters}{a FlowScreenFieldInputParameter}
#'  \item{isRequired}{a character either 'true' or 'false'}
#'  \item{isVisible}{a character either 'true' or 'false'}
#'  \item{outputParameters}{a FlowScreenFieldOutputParameter}
#'  \item{scale}{an integer}
#'  \item{validationRule}{a FlowInputValidationRule}
#' }
#'
#' \strong{FlowScreenFieldInputParameter}
#'
#' \describe{
#'  \item{processMetadataValues}{a FlowMetadataValue (inherited from FlowBaseElement)}
#'  \item{name}{a character}
#'  \item{value}{a FlowElementReferenceOrValue}
#' }
#'
#' \strong{FlowScreenFieldOutputParameter}
#'
#' \describe{
#'  \item{processMetadataValues}{a FlowMetadataValue (inherited from FlowBaseElement)}
#'  \item{assignToReference}{a character}
#'  \item{name}{a character}
#' }
#'
#' \strong{FlowScreenFieldTranslation}
#'
#' \describe{
#'  \item{fieldText}{a character}
#'  \item{helpText}{a character}
#'  \item{name}{a character}
#'  \item{validationRule}{a FlowInputValidationRuleTranslation}
#' }
#'
#' \strong{FlowScreenRule}
#'
#' \describe{
#'  \item{processMetadataValues}{a FlowMetadataValue (inherited from FlowBaseElement)}
#'  \item{conditionLogic}{a character}
#'  \item{conditions}{a FlowCondition}
#'  \item{label}{a character}
#'  \item{ruleActions}{a FlowScreenRuleAction}
#' }
#'
#' \strong{FlowScreenRuleAction}
#'
#' \describe{
#'  \item{processMetadataValues}{a FlowMetadataValue (inherited from FlowBaseElement)}
#'  \item{attribute}{a character}
#'  \item{fieldReference}{a character}
#'  \item{value}{a FlowElementReferenceOrValue}
#' }
#'
#' \strong{FlowScreenTranslation}
#'
#' \describe{
#'  \item{fields}{a FlowScreenFieldTranslation}
#'  \item{helpText}{a character}
#'  \item{name}{a character}
#'  \item{pausedText}{a character}
#' }
#'
#' \strong{FlowStage}
#'
#' \describe{
#'  \item{description}{a character (inherited from FlowElement)}
#'  \item{name}{a character (inherited from FlowElement)}
#'  \item{isActive}{a character either 'true' or 'false'}
#'  \item{label}{a character}
#'  \item{stageOrder}{an integer}
#' }
#'
#' \strong{FlowStep}
#'
#' \describe{
#'  \item{label}{a character (inherited from FlowNode)}
#'  \item{locationX}{an integer (inherited from FlowNode)}
#'  \item{locationY}{an integer (inherited from FlowNode)}
#'  \item{connectors}{a FlowConnector}
#' }
#'
#' \strong{FlowSubflow}
#'
#' \describe{
#'  \item{label}{a character (inherited from FlowNode)}
#'  \item{locationX}{an integer (inherited from FlowNode)}
#'  \item{locationY}{an integer (inherited from FlowNode)}
#'  \item{connector}{a FlowConnector}
#'  \item{flowName}{a character}
#'  \item{inputAssignments}{a FlowSubflowInputAssignment}
#'  \item{outputAssignments}{a FlowSubflowOutputAssignment}
#' }
#'
#' \strong{FlowSubflowInputAssignment}
#'
#' \describe{
#'  \item{processMetadataValues}{a FlowMetadataValue (inherited from FlowBaseElement)}
#'  \item{name}{a character}
#'  \item{value}{a FlowElementReferenceOrValue}
#' }
#'
#' \strong{FlowSubflowOutputAssignment}
#'
#' \describe{
#'  \item{processMetadataValues}{a FlowMetadataValue (inherited from FlowBaseElement)}
#'  \item{assignToReference}{a character}
#'  \item{name}{a character}
#' }
#'
#' \strong{FlowTextTemplate}
#'
#' \describe{
#'  \item{description}{a character (inherited from FlowElement)}
#'  \item{name}{a character (inherited from FlowElement)}
#'  \item{text}{a character}
#' }
#'
#' \strong{FlowTranslation}
#'
#' \describe{
#'  \item{choices}{a FlowChoiceTranslation}
#'  \item{fullName}{a character}
#'  \item{label}{a character}
#'  \item{screens}{a FlowScreenTranslation}
#' }
#'
#' \strong{FlowVariable}
#'
#' \describe{
#'  \item{description}{a character (inherited from FlowElement)}
#'  \item{name}{a character (inherited from FlowElement)}
#'  \item{dataType}{a FlowDataType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Currency}
#'      \item{Date}
#'      \item{Number}
#'      \item{String}
#'      \item{Boolean}
#'      \item{SObject}
#'      \item{DateTime}
#'      \item{Picklist}
#'      \item{Multipicklist}
#'    }
#'   }
#'  \item{isCollection}{a character either 'true' or 'false'}
#'  \item{isInput}{a character either 'true' or 'false'}
#'  \item{isOutput}{a character either 'true' or 'false'}
#'  \item{objectType}{a character}
#'  \item{scale}{an integer}
#'  \item{value}{a FlowElementReferenceOrValue}
#' }
#'
#' \strong{FlowWait}
#'
#' \describe{
#'  \item{label}{a character (inherited from FlowNode)}
#'  \item{locationX}{an integer (inherited from FlowNode)}
#'  \item{locationY}{an integer (inherited from FlowNode)}
#'  \item{defaultConnector}{a FlowConnector}
#'  \item{defaultConnectorLabel}{a character}
#'  \item{faultConnector}{a FlowConnector}
#'  \item{waitEvents}{a FlowWaitEvent}
#' }
#'
#' \strong{FlowWaitEvent}
#'
#' \describe{
#'  \item{description}{a character (inherited from FlowElement)}
#'  \item{name}{a character (inherited from FlowElement)}
#'  \item{conditionLogic}{a character}
#'  \item{conditions}{a FlowCondition}
#'  \item{connector}{a FlowConnector}
#'  \item{eventType}{a character}
#'  \item{inputParameters}{a FlowWaitEventInputParameter}
#'  \item{label}{a character}
#'  \item{outputParameters}{a FlowWaitEventOutputParameter}
#' }
#'
#' \strong{FlowWaitEventInputParameter}
#'
#' \describe{
#'  \item{processMetadataValues}{a FlowMetadataValue (inherited from FlowBaseElement)}
#'  \item{name}{a character}
#'  \item{value}{a FlowElementReferenceOrValue}
#' }
#'
#' \strong{FlowWaitEventOutputParameter}
#'
#' \describe{
#'  \item{processMetadataValues}{a FlowMetadataValue (inherited from FlowBaseElement)}
#'  \item{assignToReference}{a character}
#'  \item{name}{a character}
#' }
#'
#' \strong{Folder}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{accessType}{a FolderAccessTypes - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Shared}
#'      \item{Public}
#'      \item{Hidden}
#'      \item{PublicInternal}
#'    }
#'   }
#'  \item{folderShares}{a FolderShare}
#'  \item{name}{a character}
#'  \item{publicFolderAccess}{a PublicFolderAccess - which is a character taking one of the following values:
#'    \itemize{
#'      \item{ReadOnly}
#'      \item{ReadWrite}
#'    }
#'   }
#'  \item{sharedTo}{a SharedTo}
#' }
#'
#' \strong{FolderShare}
#'
#' \describe{
#'  \item{accessLevel}{a FolderShareAccessLevel - which is a character taking one of the following values:
#'    \itemize{
#'      \item{View}
#'      \item{EditAllContents}
#'      \item{Manage}
#'    }
#'   }
#'  \item{sharedTo}{a character}
#'  \item{sharedToType}{a FolderSharedToType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Group}
#'      \item{Role}
#'      \item{RoleAndSubordinates}
#'      \item{RoleAndSubordinatesInternal}
#'      \item{Manager}
#'      \item{ManagerAndSubordinatesInternal}
#'      \item{Organization}
#'      \item{Territory}
#'      \item{TerritoryAndSubordinates}
#'      \item{AllPrmUsers}
#'      \item{User}
#'      \item{PartnerUser}
#'      \item{AllCspUsers}
#'      \item{CustomerPortalUser}
#'      \item{PortalRole}
#'      \item{PortalRoleAndSubordinates}
#'      \item{ChannelProgramGroup}
#'    }
#'   }
#' }
#'
#' \strong{ForecastingCategoryMapping}
#'
#' \describe{
#'  \item{forecastingItemCategoryApiName}{a character}
#'  \item{weightedSourceCategories}{a WeightedSourceCategory}
#' }
#'
#' \strong{ForecastingDisplayedFamilySettings}
#'
#' \describe{
#'  \item{productFamily}{a character}
#' }
#'
#' \strong{ForecastingSettings}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{displayCurrency}{a DisplayCurrency - which is a character taking one of the following values:
#'    \itemize{
#'      \item{CORPORATE}
#'      \item{PERSONAL}
#'    }
#'   }
#'  \item{enableForecasts}{a character either 'true' or 'false'}
#'  \item{forecastingCategoryMappings}{a ForecastingCategoryMapping}
#'  \item{forecastingDisplayedFamilySettings}{a ForecastingDisplayedFamilySettings}
#'  \item{forecastingTypeSettings}{a ForecastingTypeSettings}
#' }
#'
#' \strong{ForecastingTypeSettings}
#'
#' \describe{
#'  \item{active}{a character either 'true' or 'false'}
#'  \item{adjustmentsSettings}{a AdjustmentsSettings}
#'  \item{displayedCategoryApiNames}{a character}
#'  \item{forecastRangeSettings}{a ForecastRangeSettings}
#'  \item{forecastedCategoryApiNames}{a character}
#'  \item{forecastingDateType}{a ForecastingDateType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{OpportunityCloseDate}
#'      \item{ProductDate}
#'      \item{ScheduleDate}
#'    }
#'   }
#'  \item{hasProductFamily}{a character either 'true' or 'false'}
#'  \item{isAmount}{a character either 'true' or 'false'}
#'  \item{isAvailable}{a character either 'true' or 'false'}
#'  \item{isQuantity}{a character either 'true' or 'false'}
#'  \item{managerAdjustableCategoryApiNames}{a character}
#'  \item{masterLabel}{a character}
#'  \item{name}{a character}
#'  \item{opportunityListFieldsLabelMappings}{a OpportunityListFieldsLabelMapping}
#'  \item{opportunityListFieldsSelectedSettings}{a OpportunityListFieldsSelectedSettings}
#'  \item{opportunityListFieldsUnselectedSettings}{a OpportunityListFieldsUnselectedSettings}
#'  \item{opportunitySplitName}{a character}
#'  \item{ownerAdjustableCategoryApiNames}{a character}
#'  \item{quotasSettings}{a QuotasSettings}
#'  \item{territory2ModelName}{a character}
#' }
#'
#' \strong{ForecastRangeSettings}
#'
#' \describe{
#'  \item{beginning}{an integer}
#'  \item{displaying}{an integer}
#'  \item{periodType}{a PeriodTypes - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Month}
#'      \item{Quarter}
#'      \item{Week}
#'      \item{Year}
#'    }
#'   }
#' }
#'
#' \strong{GlobalPicklistValue}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{color}{a character}
#'  \item{default}{a character either 'true' or 'false'}
#'  \item{description}{a character}
#'  \item{isActive}{a character either 'true' or 'false'}
#' }
#'
#' \strong{GlobalQuickActionTranslation}
#'
#' \describe{
#'  \item{label}{a character}
#'  \item{name}{a character}
#' }
#'
#' \strong{GlobalValueSet}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{customValue}{a CustomValue}
#'  \item{description}{a character}
#'  \item{masterLabel}{a character}
#'  \item{sorted}{a character either 'true' or 'false'}
#' }
#'
#' \strong{GlobalValueSetTranslation}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{valueTranslation}{a ValueTranslation}
#' }
#'
#' \strong{Group}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{doesIncludeBosses}{a character either 'true' or 'false'}
#'  \item{name}{a character}
#' }
#'
#' \strong{HistoryRetentionPolicy}
#'
#' \describe{
#'  \item{archiveAfterMonths}{an integer}
#'  \item{archiveRetentionYears}{an integer}
#'  \item{description}{a character}
#' }
#'
#' \strong{Holiday}
#'
#' \describe{
#'  \item{activityDate}{a character formatted as 'yyyy-mm-dd'}
#'  \item{businessHours}{a character}
#'  \item{description}{a character}
#'  \item{endTime}{a character formatted as 'hh:mm:ssZ}
#'  \item{isRecurring}{a character either 'true' or 'false'}
#'  \item{name}{a character}
#'  \item{recurrenceDayOfMonth}{an integer}
#'  \item{recurrenceDayOfWeek}{a character}
#'  \item{recurrenceDayOfWeekMask}{an integer}
#'  \item{recurrenceEndDate}{a character formatted as 'yyyy-mm-dd'}
#'  \item{recurrenceInstance}{a character}
#'  \item{recurrenceInterval}{an integer}
#'  \item{recurrenceMonthOfYear}{a character}
#'  \item{recurrenceStartDate}{a character formatted as 'yyyy-mm-dd'}
#'  \item{recurrenceType}{a character}
#'  \item{startTime}{a character formatted as 'hh:mm:ssZ}
#' }
#'
#' \strong{HomePageComponent}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{body}{a character}
#'  \item{height}{an integer}
#'  \item{links}{a character}
#'  \item{page}{a character}
#'  \item{pageComponentType}{a PageComponentType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{links}
#'      \item{htmlArea}
#'      \item{imageOrNote}
#'      \item{visualforcePage}
#'    }
#'   }
#'  \item{showLabel}{a character either 'true' or 'false'}
#'  \item{showScrollbars}{a character either 'true' or 'false'}
#'  \item{width}{a PageComponentWidth - which is a character taking one of the following values:
#'    \itemize{
#'      \item{narrow}
#'      \item{wide}
#'    }
#'   }
#' }
#'
#' \strong{HomePageLayout}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{narrowComponents}{a character}
#'  \item{wideComponents}{a character}
#' }
#'
#' \strong{IdeaReputationLevel}
#'
#' \describe{
#'  \item{name}{a character}
#'  \item{value}{an integer}
#' }
#'
#' \strong{IdeasSettings}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{enableChatterProfile}{a character either 'true' or 'false'}
#'  \item{enableIdeaThemes}{a character either 'true' or 'false'}
#'  \item{enableIdeas}{a character either 'true' or 'false'}
#'  \item{enableIdeasReputation}{a character either 'true' or 'false'}
#'  \item{halfLife}{a numeric}
#'  \item{ideasProfilePage}{a character}
#' }
#'
#' \strong{Index}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{fields}{a IndexField}
#'  \item{label}{a character}
#' }
#'
#' \strong{IndexField}
#'
#' \describe{
#'  \item{name}{a character}
#'  \item{sortDirection}{a character}
#' }
#'
#' \strong{InsightType}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{defaultTrendType}{a InsightTrendType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Positive}
#'      \item{Negative}
#'      \item{Informational}
#'      \item{Suggestion}
#'    }
#'   }
#'  \item{description}{a character}
#'  \item{isProtected}{a character either 'true' or 'false'}
#'  \item{masterLabel}{a character}
#'  \item{parentType}{a InsightParentType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Opportunity}
#'      \item{Account}
#'    }
#'   }
#'  \item{title}{a character}
#' }
#'
#' \strong{InstalledPackage}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{password}{a character}
#'  \item{versionNumber}{a character}
#' }
#'
#' \strong{IntegrationHubSettings}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{canonicalName}{a character}
#'  \item{canonicalNameBindingChar}{a character}
#'  \item{description}{a character}
#'  \item{isEnabled}{a character either 'true' or 'false'}
#'  \item{isProtected}{a character either 'true' or 'false'}
#'  \item{masterLabel}{a character}
#'  \item{setupData}{a character}
#'  \item{setupDefinition}{a character}
#'  \item{setupNamespace}{a character}
#'  \item{setupSimpleName}{a character}
#'  \item{uUID}{a character}
#'  \item{version}{a character}
#'  \item{versionBuild}{an integer}
#'  \item{versionMajor}{an integer}
#'  \item{versionMinor}{an integer}
#' }
#'
#' \strong{IntegrationHubSettingsType}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{canonicalName}{a character}
#'  \item{canonicalNameBindingChar}{a character}
#'  \item{description}{a character}
#'  \item{isEnabled}{a character either 'true' or 'false'}
#'  \item{isProtected}{a character either 'true' or 'false'}
#'  \item{masterLabel}{a character}
#'  \item{setupNamespace}{a character}
#'  \item{setupSimpleName}{a character}
#'  \item{uUID}{a character}
#'  \item{version}{a character}
#'  \item{versionBuild}{an integer}
#'  \item{versionMajor}{an integer}
#'  \item{versionMinor}{an integer}
#' }
#'
#' \strong{IpRange}
#'
#' \describe{
#'  \item{description}{a character}
#'  \item{end}{a character}
#'  \item{start}{a character}
#' }
#'
#' \strong{KeyboardShortcuts}
#'
#' \describe{
#'  \item{customShortcuts}{a CustomShortcut}
#'  \item{defaultShortcuts}{a DefaultShortcut}
#' }
#'
#' \strong{Keyword}
#'
#' \describe{
#'  \item{keyword}{a character}
#' }
#'
#' \strong{KeywordList}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{description}{a character}
#'  \item{keywords}{a Keyword}
#'  \item{masterLabel}{a character}
#' }
#'
#' \strong{KnowledgeAnswerSettings}
#'
#' \describe{
#'  \item{assignTo}{a character}
#'  \item{defaultArticleType}{a character}
#'  \item{enableArticleCreation}{a character either 'true' or 'false'}
#' }
#'
#' \strong{KnowledgeCaseField}
#'
#' \describe{
#'  \item{name}{a character}
#' }
#'
#' \strong{KnowledgeCaseFieldsSettings}
#'
#' \describe{
#'  \item{field}{a KnowledgeCaseField}
#' }
#'
#' \strong{KnowledgeCaseSettings}
#'
#' \describe{
#'  \item{articlePDFCreationProfile}{a character}
#'  \item{articlePublicSharingCommunities}{a KnowledgeCommunitiesSettings}
#'  \item{articlePublicSharingSites}{a KnowledgeSitesSettings}
#'  \item{articlePublicSharingSitesChatterAnswers}{a KnowledgeSitesSettings}
#'  \item{assignTo}{a character}
#'  \item{customizationClass}{a character}
#'  \item{defaultContributionArticleType}{a character}
#'  \item{editor}{a KnowledgeCaseEditor - which is a character taking one of the following values:
#'    \itemize{
#'      \item{simple}
#'      \item{standard}
#'    }
#'   }
#'  \item{enableArticleCreation}{a character either 'true' or 'false'}
#'  \item{enableArticlePublicSharingSites}{a character either 'true' or 'false'}
#'  \item{enableCaseDataCategoryMapping}{a character either 'true' or 'false'}
#'  \item{useProfileForPDFCreation}{a character either 'true' or 'false'}
#' }
#'
#' \strong{KnowledgeCommunitiesSettings}
#'
#' \describe{
#'  \item{community}{a character}
#' }
#'
#' \strong{KnowledgeLanguage}
#'
#' \describe{
#'  \item{active}{a character either 'true' or 'false'}
#'  \item{defaultAssignee}{a character}
#'  \item{defaultAssigneeType}{a KnowledgeLanguageLookupValueType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{User}
#'      \item{Queue}
#'    }
#'   }
#'  \item{defaultReviewer}{a character}
#'  \item{defaultReviewerType}{a KnowledgeLanguageLookupValueType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{User}
#'      \item{Queue}
#'    }
#'   }
#'  \item{name}{a character}
#' }
#'
#' \strong{KnowledgeLanguageSettings}
#'
#' \describe{
#'  \item{language}{a KnowledgeLanguage}
#' }
#'
#' \strong{KnowledgeSettings}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{answers}{a KnowledgeAnswerSettings}
#'  \item{cases}{a KnowledgeCaseSettings}
#'  \item{defaultLanguage}{a character}
#'  \item{enableChatterQuestionKBDeflection}{a character either 'true' or 'false'}
#'  \item{enableCreateEditOnArticlesTab}{a character either 'true' or 'false'}
#'  \item{enableExternalMediaContent}{a character either 'true' or 'false'}
#'  \item{enableKnowledge}{a character either 'true' or 'false'}
#'  \item{enableLightningKnowledge}{a character either 'true' or 'false'}
#'  \item{languages}{a KnowledgeLanguageSettings}
#'  \item{showArticleSummariesCustomerPortal}{a character either 'true' or 'false'}
#'  \item{showArticleSummariesInternalApp}{a character either 'true' or 'false'}
#'  \item{showArticleSummariesPartnerPortal}{a character either 'true' or 'false'}
#'  \item{showValidationStatusField}{a character either 'true' or 'false'}
#'  \item{suggestedArticles}{a KnowledgeSuggestedArticlesSettings}
#' }
#'
#' \strong{KnowledgeSitesSettings}
#'
#' \describe{
#'  \item{site}{a character}
#' }
#'
#' \strong{KnowledgeSuggestedArticlesSettings}
#'
#' \describe{
#'  \item{caseFields}{a KnowledgeCaseFieldsSettings}
#'  \item{useSuggestedArticlesForCase}{a character either 'true' or 'false'}
#'  \item{workOrderFields}{a KnowledgeWorkOrderFieldsSettings}
#'  \item{workOrderLineItemFields}{a KnowledgeWorkOrderLineItemFieldsSettings}
#' }
#'
#' \strong{KnowledgeWorkOrderField}
#'
#' \describe{
#'  \item{name}{a character}
#' }
#'
#' \strong{KnowledgeWorkOrderFieldsSettings}
#'
#' \describe{
#'  \item{field}{a KnowledgeWorkOrderField}
#' }
#'
#' \strong{KnowledgeWorkOrderLineItemField}
#'
#' \describe{
#'  \item{name}{a character}
#' }
#'
#' \strong{KnowledgeWorkOrderLineItemFieldsSettings}
#'
#' \describe{
#'  \item{field}{a KnowledgeWorkOrderLineItemField}
#' }
#'
#' \strong{Layout}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{customButtons}{a character}
#'  \item{customConsoleComponents}{a CustomConsoleComponents}
#'  \item{emailDefault}{a character either 'true' or 'false'}
#'  \item{excludeButtons}{a character}
#'  \item{feedLayout}{a FeedLayout}
#'  \item{headers}{a LayoutHeader - which is a character taking one of the following values:
#'    \itemize{
#'      \item{PersonalTagging}
#'      \item{PublicTagging}
#'    }
#'   }
#'  \item{layoutSections}{a LayoutSection}
#'  \item{miniLayout}{a MiniLayout}
#'  \item{multilineLayoutFields}{a character}
#'  \item{platformActionList}{a PlatformActionList}
#'  \item{quickActionList}{a QuickActionList}
#'  \item{relatedContent}{a RelatedContent}
#'  \item{relatedLists}{a RelatedListItem}
#'  \item{relatedObjects}{a character}
#'  \item{runAssignmentRulesDefault}{a character either 'true' or 'false'}
#'  \item{showEmailCheckbox}{a character either 'true' or 'false'}
#'  \item{showHighlightsPanel}{a character either 'true' or 'false'}
#'  \item{showInteractionLogPanel}{a character either 'true' or 'false'}
#'  \item{showKnowledgeComponent}{a character either 'true' or 'false'}
#'  \item{showRunAssignmentRulesCheckbox}{a character either 'true' or 'false'}
#'  \item{showSolutionSection}{a character either 'true' or 'false'}
#'  \item{showSubmitAndAttachButton}{a character either 'true' or 'false'}
#'  \item{summaryLayout}{a SummaryLayout}
#' }
#'
#' \strong{LayoutColumn}
#'
#' \describe{
#'  \item{layoutItems}{a LayoutItem}
#'  \item{reserved}{a character}
#' }
#'
#' \strong{LayoutItem}
#'
#' \describe{
#'  \item{analyticsCloudComponent}{a AnalyticsCloudComponentLayoutItem}
#'  \item{behavior}{a UiBehavior - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Edit}
#'      \item{Required}
#'      \item{Readonly}
#'    }
#'   }
#'  \item{canvas}{a character}
#'  \item{component}{a character}
#'  \item{customLink}{a character}
#'  \item{emptySpace}{a character either 'true' or 'false'}
#'  \item{field}{a character}
#'  \item{height}{an integer}
#'  \item{page}{a character}
#'  \item{reportChartComponent}{a ReportChartComponentLayoutItem}
#'  \item{scontrol}{a character}
#'  \item{showLabel}{a character either 'true' or 'false'}
#'  \item{showScrollbars}{a character either 'true' or 'false'}
#'  \item{width}{a character}
#' }
#'
#' \strong{LayoutSection}
#'
#' \describe{
#'  \item{customLabel}{a character either 'true' or 'false'}
#'  \item{detailHeading}{a character either 'true' or 'false'}
#'  \item{editHeading}{a character either 'true' or 'false'}
#'  \item{label}{a character}
#'  \item{layoutColumns}{a LayoutColumn}
#'  \item{style}{a LayoutSectionStyle - which is a character taking one of the following values:
#'    \itemize{
#'      \item{TwoColumnsTopToBottom}
#'      \item{TwoColumnsLeftToRight}
#'      \item{OneColumn}
#'      \item{CustomLinks}
#'    }
#'   }
#' }
#'
#' \strong{LayoutSectionTranslation}
#'
#' \describe{
#'  \item{label}{a character}
#'  \item{section}{a character}
#' }
#'
#' \strong{LayoutTranslation}
#'
#' \describe{
#'  \item{layout}{a character}
#'  \item{layoutType}{a character}
#'  \item{sections}{a LayoutSectionTranslation}
#' }
#'
#' \strong{LeadConvertSettings}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{allowOwnerChange}{a character either 'true' or 'false'}
#'  \item{objectMapping}{a ObjectMapping}
#'  \item{opportunityCreationOptions}{a VisibleOrRequired - which is a character taking one of the following values:
#'    \itemize{
#'      \item{VisibleOptional}
#'      \item{VisibleRequired}
#'      \item{NotVisible}
#'    }
#'   }
#' }
#'
#' \strong{Letterhead}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{available}{a character either 'true' or 'false'}
#'  \item{backgroundColor}{a character}
#'  \item{bodyColor}{a character}
#'  \item{bottomLine}{a LetterheadLine}
#'  \item{description}{a character}
#'  \item{footer}{a LetterheadHeaderFooter}
#'  \item{header}{a LetterheadHeaderFooter}
#'  \item{middleLine}{a LetterheadLine}
#'  \item{name}{a character}
#'  \item{topLine}{a LetterheadLine}
#' }
#'
#' \strong{LetterheadHeaderFooter}
#'
#' \describe{
#'  \item{backgroundColor}{a character}
#'  \item{height}{an integer}
#'  \item{horizontalAlignment}{a LetterheadHorizontalAlignment - which is a character taking one of the following values:
#'    \itemize{
#'      \item{None}
#'      \item{Left}
#'      \item{Center}
#'      \item{Right}
#'    }
#'   }
#'  \item{logo}{a character}
#'  \item{verticalAlignment}{a LetterheadVerticalAlignment - which is a character taking one of the following values:
#'    \itemize{
#'      \item{None}
#'      \item{Top}
#'      \item{Middle}
#'      \item{Bottom}
#'    }
#'   }
#' }
#'
#' \strong{LetterheadLine}
#'
#' \describe{
#'  \item{color}{a character}
#'  \item{height}{an integer}
#' }
#'
#' \strong{LicensedCustomPermissions}
#'
#' \describe{
#'  \item{customPermission}{a character}
#'  \item{licenseDefinition}{a character}
#' }
#'
#' \strong{LicenseDefinition}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{aggregationGroup}{a character}
#'  \item{description}{a character}
#'  \item{isPublished}{a character either 'true' or 'false'}
#'  \item{label}{a character}
#'  \item{licensedCustomPermissions}{a LicensedCustomPermissions}
#'  \item{licensingAuthority}{a character}
#'  \item{licensingAuthorityProvider}{a character}
#'  \item{minPlatformVersion}{an integer}
#'  \item{origin}{a character}
#'  \item{revision}{an integer}
#'  \item{trialLicenseDuration}{an integer}
#'  \item{trialLicenseQuantity}{an integer}
#' }
#'
#' \strong{LightningBolt}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{category}{a LightningBoltCategory - which is a character taking one of the following values:
#'    \itemize{
#'      \item{IT}
#'      \item{Marketing}
#'      \item{Sales}
#'      \item{Service}
#'    }
#'   }
#'  \item{lightningBoltFeatures}{a LightningBoltFeatures}
#'  \item{lightningBoltImages}{a LightningBoltImages}
#'  \item{lightningBoltItems}{a LightningBoltItems}
#'  \item{masterLabel}{a character}
#'  \item{publisher}{a character}
#'  \item{summary}{a character}
#' }
#'
#' \strong{LightningBoltFeatures}
#'
#' \describe{
#'  \item{description}{a character}
#'  \item{order}{an integer}
#'  \item{title}{a character}
#' }
#'
#' \strong{LightningBoltImages}
#'
#' \describe{
#'  \item{image}{a character}
#'  \item{order}{an integer}
#' }
#'
#' \strong{LightningBoltItems}
#'
#' \describe{
#'  \item{name}{a character}
#'  \item{type}{a character}
#' }
#'
#' \strong{LightningComponentBundle}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{apiVersion}{a numeric}
#'  \item{isExposed}{a character either 'true' or 'false'}
#' }
#'
#' \strong{LightningExperienceTheme}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{defaultBrandingSet}{a character}
#'  \item{description}{a character}
#'  \item{masterLabel}{a character}
#'  \item{shouldOverrideLoadingImage}{a character either 'true' or 'false'}
#' }
#'
#' \strong{ListMetadataQuery}
#'
#' \describe{
#'  \item{folder}{a character}
#'  \item{type}{a character}
#' }
#'
#' \strong{ListPlacement}
#'
#' \describe{
#'  \item{height}{an integer}
#'  \item{location}{a character}
#'  \item{units}{a character}
#'  \item{width}{an integer}
#' }
#'
#' \strong{ListView}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{booleanFilter}{a character}
#'  \item{columns}{a character}
#'  \item{division}{a character}
#'  \item{filterScope}{a FilterScope - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Everything}
#'      \item{Mine}
#'      \item{Queue}
#'      \item{Delegated}
#'      \item{MyTerritory}
#'      \item{MyTeamTerritory}
#'      \item{Team}
#'      \item{AssignedToMe}
#'    }
#'   }
#'  \item{filters}{a ListViewFilter}
#'  \item{label}{a character}
#'  \item{language}{a Language - which is a character taking one of the following values:
#'    \itemize{
#'      \item{en_US}
#'      \item{de}
#'      \item{es}
#'      \item{fr}
#'      \item{it}
#'      \item{ja}
#'      \item{sv}
#'      \item{ko}
#'      \item{zh_TW}
#'      \item{zh_CN}
#'      \item{pt_BR}
#'      \item{nl_NL}
#'      \item{da}
#'      \item{th}
#'      \item{fi}
#'      \item{ru}
#'      \item{es_MX}
#'      \item{no}
#'      \item{hu}
#'      \item{pl}
#'      \item{cs}
#'      \item{tr}
#'      \item{in}
#'      \item{ro}
#'      \item{vi}
#'      \item{uk}
#'      \item{iw}
#'      \item{el}
#'      \item{bg}
#'      \item{en_GB}
#'      \item{ar}
#'      \item{sk}
#'      \item{pt_PT}
#'      \item{hr}
#'      \item{sl}
#'      \item{fr_CA}
#'      \item{ka}
#'      \item{sr}
#'      \item{sh}
#'      \item{en_AU}
#'      \item{en_MY}
#'      \item{en_IN}
#'      \item{en_PH}
#'      \item{en_CA}
#'      \item{ro_MD}
#'      \item{bs}
#'      \item{mk}
#'      \item{lv}
#'      \item{lt}
#'      \item{et}
#'      \item{sq}
#'      \item{sh_ME}
#'      \item{mt}
#'      \item{ga}
#'      \item{eu}
#'      \item{cy}
#'      \item{is}
#'      \item{ms}
#'      \item{tl}
#'      \item{lb}
#'      \item{rm}
#'      \item{hy}
#'      \item{hi}
#'      \item{ur}
#'      \item{bn}
#'      \item{de_AT}
#'      \item{de_CH}
#'      \item{ta}
#'      \item{ar_DZ}
#'      \item{ar_BH}
#'      \item{ar_EG}
#'      \item{ar_IQ}
#'      \item{ar_JO}
#'      \item{ar_KW}
#'      \item{ar_LB}
#'      \item{ar_LY}
#'      \item{ar_MA}
#'      \item{ar_OM}
#'      \item{ar_QA}
#'      \item{ar_SA}
#'      \item{ar_SD}
#'      \item{ar_SY}
#'      \item{ar_TN}
#'      \item{ar_AE}
#'      \item{ar_YE}
#'      \item{zh_SG}
#'      \item{zh_HK}
#'      \item{en_HK}
#'      \item{en_IE}
#'      \item{en_SG}
#'      \item{en_ZA}
#'      \item{fr_BE}
#'      \item{fr_LU}
#'      \item{fr_CH}
#'      \item{de_BE}
#'      \item{de_LU}
#'      \item{it_CH}
#'      \item{nl_BE}
#'      \item{es_AR}
#'      \item{es_BO}
#'      \item{es_CL}
#'      \item{es_CO}
#'      \item{es_CR}
#'      \item{es_DO}
#'      \item{es_EC}
#'      \item{es_SV}
#'      \item{es_GT}
#'      \item{es_HN}
#'      \item{es_NI}
#'      \item{es_PA}
#'      \item{es_PY}
#'      \item{es_PE}
#'      \item{es_PR}
#'      \item{es_US}
#'      \item{es_UY}
#'      \item{es_VE}
#'      \item{ca}
#'      \item{eo}
#'      \item{iw_EO}
#'    }
#'   }
#'  \item{queue}{a character}
#'  \item{sharedTo}{a SharedTo}
#' }
#'
#' \strong{ListViewFilter}
#'
#' \describe{
#'  \item{field}{a character}
#'  \item{operation}{a FilterOperation - which is a character taking one of the following values:
#'    \itemize{
#'      \item{equals}
#'      \item{notEqual}
#'      \item{lessThan}
#'      \item{greaterThan}
#'      \item{lessOrEqual}
#'      \item{greaterOrEqual}
#'      \item{contains}
#'      \item{notContain}
#'      \item{startsWith}
#'      \item{includes}
#'      \item{excludes}
#'      \item{within}
#'    }
#'   }
#'  \item{value}{a character}
#' }
#'
#' \strong{LiveAgentConfig}
#'
#' \describe{
#'  \item{enableLiveChat}{a character either 'true' or 'false'}
#'  \item{openNewAccountSubtab}{a character either 'true' or 'false'}
#'  \item{openNewCaseSubtab}{a character either 'true' or 'false'}
#'  \item{openNewContactSubtab}{a character either 'true' or 'false'}
#'  \item{openNewLeadSubtab}{a character either 'true' or 'false'}
#'  \item{openNewVFPageSubtab}{a character either 'true' or 'false'}
#'  \item{pageNamesToOpen}{a character}
#'  \item{showKnowledgeArticles}{a character either 'true' or 'false'}
#' }
#'
#' \strong{LiveAgentSettings}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{enableLiveAgent}{a character either 'true' or 'false'}
#' }
#'
#' \strong{LiveChatAgentConfig}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{assignments}{a AgentConfigAssignments}
#'  \item{autoGreeting}{a character}
#'  \item{capacity}{an integer}
#'  \item{criticalWaitTime}{an integer}
#'  \item{customAgentName}{a character}
#'  \item{enableAgentFileTransfer}{a character either 'true' or 'false'}
#'  \item{enableAgentSneakPeek}{a character either 'true' or 'false'}
#'  \item{enableAssistanceFlag}{a character either 'true' or 'false'}
#'  \item{enableAutoAwayOnDecline}{a character either 'true' or 'false'}
#'  \item{enableAutoAwayOnPushTimeout}{a character either 'true' or 'false'}
#'  \item{enableChatConferencing}{a character either 'true' or 'false'}
#'  \item{enableChatMonitoring}{a character either 'true' or 'false'}
#'  \item{enableChatTransferToAgent}{a character either 'true' or 'false'}
#'  \item{enableChatTransferToButton}{a character either 'true' or 'false'}
#'  \item{enableChatTransferToSkill}{a character either 'true' or 'false'}
#'  \item{enableLogoutSound}{a character either 'true' or 'false'}
#'  \item{enableNotifications}{a character either 'true' or 'false'}
#'  \item{enableRequestSound}{a character either 'true' or 'false'}
#'  \item{enableSneakPeek}{a character either 'true' or 'false'}
#'  \item{enableVisitorBlocking}{a character either 'true' or 'false'}
#'  \item{enableWhisperMessage}{a character either 'true' or 'false'}
#'  \item{label}{a character}
#'  \item{supervisorDefaultAgentStatusFilter}{a SupervisorAgentStatusFilter - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Online}
#'      \item{Away}
#'      \item{Offline}
#'    }
#'   }
#'  \item{supervisorDefaultButtonFilter}{a character}
#'  \item{supervisorDefaultSkillFilter}{a character}
#'  \item{supervisorSkills}{a SupervisorAgentConfigSkills}
#'  \item{transferableButtons}{a AgentConfigButtons}
#'  \item{transferableSkills}{a AgentConfigSkills}
#' }
#'
#' \strong{LiveChatButton}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{animation}{a LiveChatButtonPresentation - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Slide}
#'      \item{Fade}
#'      \item{Appear}
#'      \item{Custom}
#'    }
#'   }
#'  \item{autoGreeting}{a character}
#'  \item{chasitorIdleTimeout}{an integer}
#'  \item{chasitorIdleTimeoutWarning}{an integer}
#'  \item{chatPage}{a character}
#'  \item{customAgentName}{a character}
#'  \item{deployments}{a LiveChatButtonDeployments}
#'  \item{enableQueue}{a character either 'true' or 'false'}
#'  \item{inviteEndPosition}{a LiveChatButtonInviteEndPosition - which is a character taking one of the following values:
#'    \itemize{
#'      \item{TopLeft}
#'      \item{Top}
#'      \item{TopRight}
#'      \item{Left}
#'      \item{Center}
#'      \item{Right}
#'      \item{BottomLeft}
#'      \item{Bottom}
#'      \item{BottomRight}
#'    }
#'   }
#'  \item{inviteImage}{a character}
#'  \item{inviteStartPosition}{a LiveChatButtonInviteStartPosition - which is a character taking one of the following values:
#'    \itemize{
#'      \item{TopLeft}
#'      \item{TopLeftTop}
#'      \item{Top}
#'      \item{TopRightTop}
#'      \item{TopRight}
#'      \item{TopRightRight}
#'      \item{Right}
#'      \item{BottomRightRight}
#'      \item{BottomRight}
#'      \item{BottomRightBottom}
#'      \item{Bottom}
#'      \item{BottomLeftBottom}
#'      \item{BottomLeft}
#'      \item{BottomLeftLeft}
#'      \item{Left}
#'      \item{TopLeftLeft}
#'    }
#'   }
#'  \item{isActive}{a character either 'true' or 'false'}
#'  \item{label}{a character}
#'  \item{numberOfReroutingAttempts}{an integer}
#'  \item{offlineImage}{a character}
#'  \item{onlineImage}{a character}
#'  \item{optionsCustomRoutingIsEnabled}{a character either 'true' or 'false'}
#'  \item{optionsHasChasitorIdleTimeout}{a character either 'true' or 'false'}
#'  \item{optionsHasInviteAfterAccept}{a character either 'true' or 'false'}
#'  \item{optionsHasInviteAfterReject}{a character either 'true' or 'false'}
#'  \item{optionsHasRerouteDeclinedRequest}{a character either 'true' or 'false'}
#'  \item{optionsIsAutoAccept}{a character either 'true' or 'false'}
#'  \item{optionsIsInviteAutoRemove}{a character either 'true' or 'false'}
#'  \item{overallQueueLength}{an integer}
#'  \item{perAgentQueueLength}{an integer}
#'  \item{postChatPage}{a character}
#'  \item{postChatUrl}{a character}
#'  \item{preChatFormPage}{a character}
#'  \item{preChatFormUrl}{a character}
#'  \item{pushTimeOut}{an integer}
#'  \item{routingType}{a LiveChatButtonRoutingType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Choice}
#'      \item{LeastActive}
#'      \item{MostAvailable}
#'    }
#'   }
#'  \item{site}{a character}
#'  \item{skills}{a LiveChatButtonSkills}
#'  \item{timeToRemoveInvite}{an integer}
#'  \item{type}{a LiveChatButtonType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Standard}
#'      \item{Invite}
#'    }
#'   }
#'  \item{windowLanguage}{a Language - which is a character taking one of the following values:
#'    \itemize{
#'      \item{en_US}
#'      \item{de}
#'      \item{es}
#'      \item{fr}
#'      \item{it}
#'      \item{ja}
#'      \item{sv}
#'      \item{ko}
#'      \item{zh_TW}
#'      \item{zh_CN}
#'      \item{pt_BR}
#'      \item{nl_NL}
#'      \item{da}
#'      \item{th}
#'      \item{fi}
#'      \item{ru}
#'      \item{es_MX}
#'      \item{no}
#'      \item{hu}
#'      \item{pl}
#'      \item{cs}
#'      \item{tr}
#'      \item{in}
#'      \item{ro}
#'      \item{vi}
#'      \item{uk}
#'      \item{iw}
#'      \item{el}
#'      \item{bg}
#'      \item{en_GB}
#'      \item{ar}
#'      \item{sk}
#'      \item{pt_PT}
#'      \item{hr}
#'      \item{sl}
#'      \item{fr_CA}
#'      \item{ka}
#'      \item{sr}
#'      \item{sh}
#'      \item{en_AU}
#'      \item{en_MY}
#'      \item{en_IN}
#'      \item{en_PH}
#'      \item{en_CA}
#'      \item{ro_MD}
#'      \item{bs}
#'      \item{mk}
#'      \item{lv}
#'      \item{lt}
#'      \item{et}
#'      \item{sq}
#'      \item{sh_ME}
#'      \item{mt}
#'      \item{ga}
#'      \item{eu}
#'      \item{cy}
#'      \item{is}
#'      \item{ms}
#'      \item{tl}
#'      \item{lb}
#'      \item{rm}
#'      \item{hy}
#'      \item{hi}
#'      \item{ur}
#'      \item{bn}
#'      \item{de_AT}
#'      \item{de_CH}
#'      \item{ta}
#'      \item{ar_DZ}
#'      \item{ar_BH}
#'      \item{ar_EG}
#'      \item{ar_IQ}
#'      \item{ar_JO}
#'      \item{ar_KW}
#'      \item{ar_LB}
#'      \item{ar_LY}
#'      \item{ar_MA}
#'      \item{ar_OM}
#'      \item{ar_QA}
#'      \item{ar_SA}
#'      \item{ar_SD}
#'      \item{ar_SY}
#'      \item{ar_TN}
#'      \item{ar_AE}
#'      \item{ar_YE}
#'      \item{zh_SG}
#'      \item{zh_HK}
#'      \item{en_HK}
#'      \item{en_IE}
#'      \item{en_SG}
#'      \item{en_ZA}
#'      \item{fr_BE}
#'      \item{fr_LU}
#'      \item{fr_CH}
#'      \item{de_BE}
#'      \item{de_LU}
#'      \item{it_CH}
#'      \item{nl_BE}
#'      \item{es_AR}
#'      \item{es_BO}
#'      \item{es_CL}
#'      \item{es_CO}
#'      \item{es_CR}
#'      \item{es_DO}
#'      \item{es_EC}
#'      \item{es_SV}
#'      \item{es_GT}
#'      \item{es_HN}
#'      \item{es_NI}
#'      \item{es_PA}
#'      \item{es_PY}
#'      \item{es_PE}
#'      \item{es_PR}
#'      \item{es_US}
#'      \item{es_UY}
#'      \item{es_VE}
#'      \item{ca}
#'      \item{eo}
#'      \item{iw_EO}
#'    }
#'   }
#' }
#'
#' \strong{LiveChatButtonDeployments}
#'
#' \describe{
#'  \item{deployment}{a character}
#' }
#'
#' \strong{LiveChatButtonSkills}
#'
#' \describe{
#'  \item{skill}{a character}
#' }
#'
#' \strong{LiveChatDeployment}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{brandingImage}{a character}
#'  \item{connectionTimeoutDuration}{an integer}
#'  \item{connectionWarningDuration}{an integer}
#'  \item{displayQueuePosition}{a character either 'true' or 'false'}
#'  \item{domainWhiteList}{a LiveChatDeploymentDomainWhitelist}
#'  \item{enablePrechatApi}{a character either 'true' or 'false'}
#'  \item{enableTranscriptSave}{a character either 'true' or 'false'}
#'  \item{label}{a character}
#'  \item{mobileBrandingImage}{a character}
#'  \item{site}{a character}
#'  \item{windowTitle}{a character}
#' }
#'
#' \strong{LiveChatDeploymentDomainWhitelist}
#'
#' \describe{
#'  \item{domain}{a character}
#' }
#'
#' \strong{LiveChatSensitiveDataRule}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{actionType}{a SensitiveDataActionType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Remove}
#'      \item{Replace}
#'    }
#'   }
#'  \item{description}{a character}
#'  \item{enforceOn}{an integer}
#'  \item{isEnabled}{a character either 'true' or 'false'}
#'  \item{pattern}{a character}
#'  \item{replacement}{a character}
#' }
#'
#' \strong{LiveMessageSettings}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{enableLiveMessage}{a character either 'true' or 'false'}
#' }
#'
#' \strong{LogInfo}
#'
#' \describe{
#'  \item{category}{a LogCategory - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Db}
#'      \item{Workflow}
#'      \item{Validation}
#'      \item{Callout}
#'      \item{Apex_code}
#'      \item{Apex_profiling}
#'      \item{Visualforce}
#'      \item{System}
#'      \item{Wave}
#'      \item{All}
#'    }
#'   }
#'  \item{level}{a LogCategoryLevel - which is a character taking one of the following values:
#'    \itemize{
#'      \item{None}
#'      \item{Finest}
#'      \item{Finer}
#'      \item{Fine}
#'      \item{Debug}
#'      \item{Info}
#'      \item{Warn}
#'      \item{Error}
#'    }
#'   }
#' }
#'
#' \strong{LookupFilter}
#'
#' \describe{
#'  \item{active}{a character either 'true' or 'false'}
#'  \item{booleanFilter}{a character}
#'  \item{description}{a character}
#'  \item{errorMessage}{a character}
#'  \item{filterItems}{a FilterItem}
#'  \item{infoMessage}{a character}
#'  \item{isOptional}{a character either 'true' or 'false'}
#' }
#'
#' \strong{LookupFilterTranslation}
#'
#' \describe{
#'  \item{errorMessage}{a character}
#'  \item{informationalMessage}{a character}
#' }
#'
#' \strong{MacroSettings}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{enableAdvancedSearch}{a character either 'true' or 'false'}
#' }
#'
#' \strong{ManagedTopic}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{managedTopicType}{a character}
#'  \item{name}{a character}
#'  \item{parentName}{a character}
#'  \item{position}{an integer}
#'  \item{topicDescription}{a character}
#' }
#'
#' \strong{ManagedTopics}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{managedTopic}{a ManagedTopic}
#' }
#'
#' \strong{MarketingActionSettings}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{enableMarketingAction}{a character either 'true' or 'false'}
#' }
#'
#' \strong{MarketingResourceType}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{description}{a character}
#'  \item{masterLabel}{a character}
#'  \item{object}{a character}
#'  \item{provider}{a character}
#' }
#'
#' \strong{MatchingRule}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{booleanFilter}{a character}
#'  \item{description}{a character}
#'  \item{label}{a character}
#'  \item{matchingRuleItems}{a MatchingRuleItem}
#'  \item{ruleStatus}{a MatchingRuleStatus - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Inactive}
#'      \item{DeactivationFailed}
#'      \item{Activating}
#'      \item{Deactivating}
#'      \item{Active}
#'      \item{ActivationFailed}
#'    }
#'   }
#' }
#'
#' \strong{MatchingRuleItem}
#'
#' \describe{
#'  \item{blankValueBehavior}{a BlankValueBehavior - which is a character taking one of the following values:
#'    \itemize{
#'      \item{MatchBlanks}
#'      \item{NullNotAllowed}
#'    }
#'   }
#'  \item{fieldName}{a character}
#'  \item{matchingMethod}{a MatchingMethod - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Exact}
#'      \item{FirstName}
#'      \item{LastName}
#'      \item{CompanyName}
#'      \item{Phone}
#'      \item{City}
#'      \item{Street}
#'      \item{Zip}
#'      \item{Title}
#'    }
#'   }
#' }
#'
#' \strong{MatchingRules}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{matchingRules}{a MatchingRule}
#' }
#'
#' \strong{Metadata}
#'
#' \describe{
#'  \item{fullName}{a character}
#' }
#'
#' \strong{MetadataWithContent}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{content}{a character formed using \code{\link[base64enc]{base64encode}}}
#' }
#'
#' \strong{MilestoneType}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{description}{a character}
#'  \item{recurrenceType}{a MilestoneTypeRecurrenceType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{none}
#'      \item{recursIndependently}
#'      \item{recursChained}
#'    }
#'   }
#' }
#'
#' \strong{MiniLayout}
#'
#' \describe{
#'  \item{fields}{a character}
#'  \item{relatedLists}{a RelatedListItem}
#' }
#'
#' \strong{MobileSettings}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{chatterMobile}{a ChatterMobileSettings}
#'  \item{dashboardMobile}{a DashboardMobileSettings}
#'  \item{salesforceMobile}{a SFDCMobileSettings}
#'  \item{touchMobile}{a TouchMobileSettings}
#' }
#'
#' \strong{ModeratedEntityField}
#'
#' \describe{
#'  \item{entityName}{a character}
#'  \item{fieldName}{a character}
#'  \item{keywordList}{a character}
#' }
#'
#' \strong{ModerationRule}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{action}{a ModerationRuleAction - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Block}
#'      \item{FreezeAndNotify}
#'      \item{Review}
#'      \item{Replace}
#'      \item{Flag}
#'    }
#'   }
#'  \item{actionLimit}{an integer}
#'  \item{active}{a character either 'true' or 'false'}
#'  \item{description}{a character}
#'  \item{entitiesAndFields}{a ModeratedEntityField}
#'  \item{masterLabel}{a character}
#'  \item{notifyLimit}{an integer}
#'  \item{timePeriod}{a RateLimitTimePeriod - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Short}
#'      \item{Medium}
#'    }
#'   }
#'  \item{type}{a ModerationRuleType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Content}
#'      \item{Rate}
#'    }
#'   }
#'  \item{userCriteria}{a character}
#'  \item{userMessage}{a character}
#' }
#'
#' \strong{NamedCredential}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{allowMergeFieldsInBody}{a character either 'true' or 'false'}
#'  \item{allowMergeFieldsInHeader}{a character either 'true' or 'false'}
#'  \item{authProvider}{a character}
#'  \item{certificate}{a character}
#'  \item{endpoint}{a character}
#'  \item{generateAuthorizationHeader}{a character either 'true' or 'false'}
#'  \item{label}{a character}
#'  \item{oauthRefreshToken}{a character}
#'  \item{oauthScope}{a character}
#'  \item{oauthToken}{a character}
#'  \item{password}{a character}
#'  \item{principalType}{a ExternalPrincipalType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Anonymous}
#'      \item{PerUser}
#'      \item{NamedUser}
#'    }
#'   }
#'  \item{protocol}{a AuthenticationProtocol - which is a character taking one of the following values:
#'    \itemize{
#'      \item{NoAuthentication}
#'      \item{Oauth}
#'      \item{Password}
#'    }
#'   }
#'  \item{username}{a character}
#' }
#'
#' \strong{NameSettings}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{enableMiddleName}{a character either 'true' or 'false'}
#'  \item{enableNameSuffix}{a character either 'true' or 'false'}
#' }
#'
#' \strong{NavigationLinkSet}
#'
#' \describe{
#'  \item{navigationMenuItem}{a NavigationMenuItem}
#' }
#'
#' \strong{NavigationMenuItem}
#'
#' \describe{
#'  \item{defaultListViewId}{a character}
#'  \item{label}{a character}
#'  \item{position}{an integer}
#'  \item{publiclyAvailable}{a character either 'true' or 'false'}
#'  \item{subMenu}{a NavigationSubMenu}
#'  \item{target}{a character}
#'  \item{targetPreference}{a character}
#'  \item{type}{a character}
#' }
#'
#' \strong{NavigationSubMenu}
#'
#' \describe{
#'  \item{navigationMenuItem}{a NavigationMenuItem}
#' }
#'
#' \strong{Network}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{allowInternalUserLogin}{a character either 'true' or 'false'}
#'  \item{allowMembersToFlag}{a character either 'true' or 'false'}
#'  \item{allowedExtensions}{a character}
#'  \item{caseCommentEmailTemplate}{a character}
#'  \item{changePasswordTemplate}{a character}
#'  \item{communityRoles}{a CommunityRoles}
#'  \item{description}{a character}
#'  \item{disableReputationRecordConversations}{a character either 'true' or 'false'}
#'  \item{emailFooterLogo}{a character}
#'  \item{emailFooterText}{a character}
#'  \item{emailSenderAddress}{a character}
#'  \item{emailSenderName}{a character}
#'  \item{enableCustomVFErrorPageOverrides}{a character either 'true' or 'false'}
#'  \item{enableDirectMessages}{a character either 'true' or 'false'}
#'  \item{enableGuestChatter}{a character either 'true' or 'false'}
#'  \item{enableGuestFileAccess}{a character either 'true' or 'false'}
#'  \item{enableInvitation}{a character either 'true' or 'false'}
#'  \item{enableKnowledgeable}{a character either 'true' or 'false'}
#'  \item{enableNicknameDisplay}{a character either 'true' or 'false'}
#'  \item{enablePrivateMessages}{a character either 'true' or 'false'}
#'  \item{enableReputation}{a character either 'true' or 'false'}
#'  \item{enableShowAllNetworkSettings}{a character either 'true' or 'false'}
#'  \item{enableSiteAsContainer}{a character either 'true' or 'false'}
#'  \item{enableTalkingAboutStats}{a character either 'true' or 'false'}
#'  \item{enableTopicAssignmentRules}{a character either 'true' or 'false'}
#'  \item{enableTopicSuggestions}{a character either 'true' or 'false'}
#'  \item{enableUpDownVote}{a character either 'true' or 'false'}
#'  \item{feedChannel}{a character}
#'  \item{forgotPasswordTemplate}{a character}
#'  \item{gatherCustomerSentimentData}{a character either 'true' or 'false'}
#'  \item{logoutUrl}{a character}
#'  \item{maxFileSizeKb}{an integer}
#'  \item{navigationLinkSet}{a NavigationLinkSet}
#'  \item{networkMemberGroups}{a NetworkMemberGroup}
#'  \item{networkPageOverrides}{a NetworkPageOverride}
#'  \item{newSenderAddress}{a character}
#'  \item{picassoSite}{a character}
#'  \item{recommendationAudience}{a RecommendationAudience}
#'  \item{recommendationDefinition}{a RecommendationDefinition}
#'  \item{reputationLevels}{a ReputationLevelDefinitions}
#'  \item{reputationPointsRules}{a ReputationPointsRules}
#'  \item{selfRegProfile}{a character}
#'  \item{selfRegistration}{a character either 'true' or 'false'}
#'  \item{sendWelcomeEmail}{a character either 'true' or 'false'}
#'  \item{site}{a character}
#'  \item{status}{a NetworkStatus - which is a character taking one of the following values:
#'    \itemize{
#'      \item{UnderConstruction}
#'      \item{Live}
#'      \item{DownForMaintenance}
#'    }
#'   }
#'  \item{tabs}{a NetworkTabSet}
#'  \item{urlPathPrefix}{a character}
#'  \item{welcomeTemplate}{a character}
#' }
#'
#' \strong{NetworkAccess}
#'
#' \describe{
#'  \item{ipRanges}{a IpRange}
#' }
#'
#' \strong{NetworkBranding}
#'
#' \describe{
#'  \item{content}{a character formed using \code{\link[base64enc]{base64encode}} (inherited from MetadataWithContent)}
#'  \item{loginFooterText}{a character}
#'  \item{loginLogo}{a character}
#'  \item{loginLogoName}{a character}
#'  \item{loginPrimaryColor}{a character}
#'  \item{loginQuaternaryColor}{a character}
#'  \item{loginRightFrameUrl}{a character}
#'  \item{network}{a character}
#'  \item{pageFooter}{a character}
#'  \item{pageHeader}{a character}
#'  \item{primaryColor}{a character}
#'  \item{primaryComplementColor}{a character}
#'  \item{quaternaryColor}{a character}
#'  \item{quaternaryComplementColor}{a character}
#'  \item{secondaryColor}{a character}
#'  \item{staticLogoImageUrl}{a character}
#'  \item{tertiaryColor}{a character}
#'  \item{tertiaryComplementColor}{a character}
#'  \item{zeronaryColor}{a character}
#'  \item{zeronaryComplementColor}{a character}
#' }
#'
#' \strong{NetworkMemberGroup}
#'
#' \describe{
#'  \item{permissionSet}{a character}
#'  \item{profile}{a character}
#' }
#'
#' \strong{NetworkPageOverride}
#'
#' \describe{
#'  \item{changePasswordPageOverrideSetting}{a NetworkPageOverrideSetting - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Designer}
#'      \item{VisualForce}
#'      \item{Standard}
#'    }
#'   }
#'  \item{forgotPasswordPageOverrideSetting}{a NetworkPageOverrideSetting - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Designer}
#'      \item{VisualForce}
#'      \item{Standard}
#'    }
#'   }
#'  \item{homePageOverrideSetting}{a NetworkPageOverrideSetting - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Designer}
#'      \item{VisualForce}
#'      \item{Standard}
#'    }
#'   }
#'  \item{loginPageOverrideSetting}{a NetworkPageOverrideSetting - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Designer}
#'      \item{VisualForce}
#'      \item{Standard}
#'    }
#'   }
#'  \item{selfRegProfilePageOverrideSetting}{a NetworkPageOverrideSetting - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Designer}
#'      \item{VisualForce}
#'      \item{Standard}
#'    }
#'   }
#' }
#'
#' \strong{NetworkTabSet}
#'
#' \describe{
#'  \item{customTab}{a character}
#'  \item{defaultTab}{a character}
#'  \item{standardTab}{a character}
#' }
#'
#' \strong{NextAutomatedApprover}
#'
#' \describe{
#'  \item{useApproverFieldOfRecordOwner}{a character either 'true' or 'false'}
#'  \item{userHierarchyField}{a character}
#' }
#'
#' \strong{ObjectMapping}
#'
#' \describe{
#'  \item{inputObject}{a character}
#'  \item{mappingFields}{a ObjectMappingField}
#'  \item{outputObject}{a character}
#' }
#'
#' \strong{ObjectMappingField}
#'
#' \describe{
#'  \item{inputField}{a character}
#'  \item{outputField}{a character}
#' }
#'
#' \strong{ObjectNameCaseValue}
#'
#' \describe{
#'  \item{article}{a Article - which is a character taking one of the following values:
#'    \itemize{
#'      \item{None}
#'      \item{Indefinite}
#'      \item{Definite}
#'    }
#'   }
#'  \item{caseType}{a CaseType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Nominative}
#'      \item{Accusative}
#'      \item{Genitive}
#'      \item{Dative}
#'      \item{Inessive}
#'      \item{Elative}
#'      \item{Illative}
#'      \item{Adessive}
#'      \item{Ablative}
#'      \item{Allative}
#'      \item{Essive}
#'      \item{Translative}
#'      \item{Partitive}
#'      \item{Objective}
#'      \item{Subjective}
#'      \item{Instrumental}
#'      \item{Prepositional}
#'      \item{Locative}
#'      \item{Vocative}
#'      \item{Sublative}
#'      \item{Superessive}
#'      \item{Delative}
#'      \item{Causalfinal}
#'      \item{Essiveformal}
#'      \item{Termanative}
#'      \item{Distributive}
#'      \item{Ergative}
#'      \item{Adverbial}
#'      \item{Abessive}
#'      \item{Comitative}
#'    }
#'   }
#'  \item{plural}{a character either 'true' or 'false'}
#'  \item{possessive}{a Possessive - which is a character taking one of the following values:
#'    \itemize{
#'      \item{None}
#'      \item{First}
#'      \item{Second}
#'    }
#'   }
#'  \item{value}{a character}
#' }
#'
#' \strong{ObjectRelationship}
#'
#' \describe{
#'  \item{join}{a ObjectRelationship}
#'  \item{outerJoin}{a character either 'true' or 'false'}
#'  \item{relationship}{a character}
#' }
#'
#' \strong{ObjectSearchSetting}
#'
#' \describe{
#'  \item{enhancedLookupEnabled}{a character either 'true' or 'false'}
#'  \item{lookupAutoCompleteEnabled}{a character either 'true' or 'false'}
#'  \item{name}{a character}
#'  \item{resultsPerPageCount}{an integer}
#' }
#'
#' \strong{ObjectUsage}
#'
#' \describe{
#'  \item{object}{a character}
#' }
#'
#' \strong{OpportunityListFieldsLabelMapping}
#'
#' \describe{
#'  \item{field}{a character}
#'  \item{label}{a character}
#' }
#'
#' \strong{OpportunityListFieldsSelectedSettings}
#'
#' \describe{
#'  \item{field}{a character}
#' }
#'
#' \strong{OpportunityListFieldsUnselectedSettings}
#'
#' \describe{
#'  \item{field}{a character}
#' }
#'
#' \strong{OpportunitySettings}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{autoActivateNewReminders}{a character either 'true' or 'false'}
#'  \item{enableFindSimilarOpportunities}{a character either 'true' or 'false'}
#'  \item{enableOpportunityTeam}{a character either 'true' or 'false'}
#'  \item{enableUpdateReminders}{a character either 'true' or 'false'}
#'  \item{findSimilarOppFilter}{a FindSimilarOppFilter}
#'  \item{promptToAddProducts}{a character either 'true' or 'false'}
#' }
#'
#' \strong{Orchestration}
#'
#' \describe{
#'  \item{content}{a character formed using \code{\link[base64enc]{base64encode}} (inherited from MetadataWithContent)}
#'  \item{context}{a character}
#'  \item{masterLabel}{a character}
#' }
#'
#' \strong{OrchestrationContext}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{description}{a character}
#'  \item{events}{a OrchestrationContextEvent}
#'  \item{masterLabel}{a character}
#'  \item{runtimeType}{a character}
#'  \item{salesforceObject}{a character}
#'  \item{salesforceObjectPrimaryKey}{a character}
#' }
#'
#' \strong{OrchestrationContextEvent}
#'
#' \describe{
#'  \item{eventType}{a character}
#'  \item{orchestrationEvent}{a character}
#'  \item{platformEvent}{a character}
#'  \item{platformEventPrimaryKey}{a character}
#' }
#'
#' \strong{OrderSettings}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{enableNegativeQuantity}{a character either 'true' or 'false'}
#'  \item{enableOrders}{a character either 'true' or 'false'}
#'  \item{enableReductionOrders}{a character either 'true' or 'false'}
#'  \item{enableZeroQuantity}{a character either 'true' or 'false'}
#' }
#'
#' \strong{OrganizationSettingsDetail}
#'
#' \describe{
#'  \item{settingName}{a character}
#'  \item{settingValue}{a character either 'true' or 'false'}
#' }
#'
#' \strong{OrgPreferenceSettings}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{preferences}{a OrganizationSettingsDetail}
#' }
#'
#' \strong{Package}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{apiAccessLevel}{a APIAccessLevel - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Unrestricted}
#'      \item{Restricted}
#'    }
#'   }
#'  \item{description}{a character}
#'  \item{namespacePrefix}{a character}
#'  \item{objectPermissions}{a ProfileObjectPermissions}
#'  \item{packageType}{a character}
#'  \item{postInstallClass}{a character}
#'  \item{setupWeblink}{a character}
#'  \item{types}{a PackageTypeMembers}
#'  \item{uninstallClass}{a character}
#'  \item{version}{a character}
#' }
#'
#' \strong{PackageTypeMembers}
#'
#' \describe{
#'  \item{members}{a character}
#'  \item{name}{a character}
#' }
#'
#' \strong{PackageVersion}
#'
#' \describe{
#'  \item{majorNumber}{an integer}
#'  \item{minorNumber}{an integer}
#'  \item{namespace}{a character}
#' }
#'
#' \strong{PasswordPolicies}
#'
#' \describe{
#'  \item{apiOnlyUserHomePageURL}{a character}
#'  \item{complexity}{a Complexity - which is a character taking one of the following values:
#'    \itemize{
#'      \item{NoRestriction}
#'      \item{AlphaNumeric}
#'      \item{SpecialCharacters}
#'      \item{UpperLowerCaseNumeric}
#'      \item{UpperLowerCaseNumericSpecialCharacters}
#'    }
#'   }
#'  \item{expiration}{a Expiration - which is a character taking one of the following values:
#'    \itemize{
#'      \item{ThirtyDays}
#'      \item{SixtyDays}
#'      \item{NinetyDays}
#'      \item{SixMonths}
#'      \item{OneYear}
#'      \item{Never}
#'    }
#'   }
#'  \item{historyRestriction}{a character}
#'  \item{lockoutInterval}{a LockoutInterval - which is a character taking one of the following values:
#'    \itemize{
#'      \item{FifteenMinutes}
#'      \item{ThirtyMinutes}
#'      \item{SixtyMinutes}
#'      \item{Forever}
#'    }
#'   }
#'  \item{maxLoginAttempts}{a MaxLoginAttempts - which is a character taking one of the following values:
#'    \itemize{
#'      \item{ThreeAttempts}
#'      \item{FiveAttempts}
#'      \item{TenAttempts}
#'      \item{NoLimit}
#'    }
#'   }
#'  \item{minimumPasswordLength}{a character}
#'  \item{minimumPasswordLifetime}{a character either 'true' or 'false'}
#'  \item{obscureSecretAnswer}{a character either 'true' or 'false'}
#'  \item{passwordAssistanceMessage}{a character}
#'  \item{passwordAssistanceURL}{a character}
#'  \item{questionRestriction}{a QuestionRestriction - which is a character taking one of the following values:
#'    \itemize{
#'      \item{None}
#'      \item{DoesNotContainPassword}
#'    }
#'   }
#' }
#'
#' \strong{PathAssistant}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{active}{a character either 'true' or 'false'}
#'  \item{entityName}{a character}
#'  \item{fieldName}{a character}
#'  \item{masterLabel}{a character}
#'  \item{pathAssistantSteps}{a PathAssistantStep}
#'  \item{recordTypeName}{a character}
#' }
#'
#' \strong{PathAssistantSettings}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{pathAssistantEnabled}{a character either 'true' or 'false'}
#' }
#'
#' \strong{PathAssistantStep}
#'
#' \describe{
#'  \item{fieldNames}{a character}
#'  \item{info}{a character}
#'  \item{picklistValueName}{a character}
#' }
#'
#' \strong{PermissionSet}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{applicationVisibilities}{a PermissionSetApplicationVisibility}
#'  \item{classAccesses}{a PermissionSetApexClassAccess}
#'  \item{customPermissions}{a PermissionSetCustomPermissions}
#'  \item{description}{a character}
#'  \item{externalDataSourceAccesses}{a PermissionSetExternalDataSourceAccess}
#'  \item{fieldPermissions}{a PermissionSetFieldPermissions}
#'  \item{hasActivationRequired}{a character either 'true' or 'false'}
#'  \item{label}{a character}
#'  \item{license}{a character}
#'  \item{objectPermissions}{a PermissionSetObjectPermissions}
#'  \item{pageAccesses}{a PermissionSetApexPageAccess}
#'  \item{recordTypeVisibilities}{a PermissionSetRecordTypeVisibility}
#'  \item{tabSettings}{a PermissionSetTabSetting}
#'  \item{userPermissions}{a PermissionSetUserPermission}
#' }
#'
#' \strong{PermissionSetApexClassAccess}
#'
#' \describe{
#'  \item{apexClass}{a character}
#'  \item{enabled}{a character either 'true' or 'false'}
#' }
#'
#' \strong{PermissionSetApexPageAccess}
#'
#' \describe{
#'  \item{apexPage}{a character}
#'  \item{enabled}{a character either 'true' or 'false'}
#' }
#'
#' \strong{PermissionSetApplicationVisibility}
#'
#' \describe{
#'  \item{application}{a character}
#'  \item{visible}{a character either 'true' or 'false'}
#' }
#'
#' \strong{PermissionSetCustomPermissions}
#'
#' \describe{
#'  \item{enabled}{a character either 'true' or 'false'}
#'  \item{name}{a character}
#' }
#'
#' \strong{PermissionSetExternalDataSourceAccess}
#'
#' \describe{
#'  \item{enabled}{a character either 'true' or 'false'}
#'  \item{externalDataSource}{a character}
#' }
#'
#' \strong{PermissionSetFieldPermissions}
#'
#' \describe{
#'  \item{editable}{a character either 'true' or 'false'}
#'  \item{field}{a character}
#'  \item{readable}{a character either 'true' or 'false'}
#' }
#'
#' \strong{PermissionSetGroup}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{description}{a character}
#'  \item{isCalculatingChanges}{a character either 'true' or 'false'}
#'  \item{label}{a character}
#'  \item{permissionSets}{a character}
#' }
#'
#' \strong{PermissionSetObjectPermissions}
#'
#' \describe{
#'  \item{allowCreate}{a character either 'true' or 'false'}
#'  \item{allowDelete}{a character either 'true' or 'false'}
#'  \item{allowEdit}{a character either 'true' or 'false'}
#'  \item{allowRead}{a character either 'true' or 'false'}
#'  \item{modifyAllRecords}{a character either 'true' or 'false'}
#'  \item{object}{a character}
#'  \item{viewAllRecords}{a character either 'true' or 'false'}
#' }
#'
#' \strong{PermissionSetRecordTypeVisibility}
#'
#' \describe{
#'  \item{recordType}{a character}
#'  \item{visible}{a character either 'true' or 'false'}
#' }
#'
#' \strong{PermissionSetTabSetting}
#'
#' \describe{
#'  \item{tab}{a character}
#'  \item{visibility}{a PermissionSetTabVisibility - which is a character taking one of the following values:
#'    \itemize{
#'      \item{None}
#'      \item{Available}
#'      \item{Visible}
#'    }
#'   }
#' }
#'
#' \strong{PermissionSetUserPermission}
#'
#' \describe{
#'  \item{enabled}{a character either 'true' or 'false'}
#'  \item{name}{a character}
#' }
#'
#' \strong{PersonalJourneySettings}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{enableExactTargetForSalesforceApps}{a character either 'true' or 'false'}
#' }
#'
#' \strong{PersonListSettings}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{enablePersonList}{a character either 'true' or 'false'}
#' }
#'
#' \strong{PicklistEntry}
#'
#' \describe{
#'  \item{active}{a character either 'true' or 'false'}
#'  \item{defaultValue}{a character either 'true' or 'false'}
#'  \item{label}{a character}
#'  \item{validFor}{a character}
#'  \item{value}{a character}
#' }
#'
#' \strong{PicklistValue}
#'
#' \describe{
#'  \item{color}{a character (inherited from GlobalPicklistValue)}
#'  \item{default}{a character either 'true' or 'false' (inherited from GlobalPicklistValue)}
#'  \item{description}{a character (inherited from GlobalPicklistValue)}
#'  \item{isActive}{a character either 'true' or 'false' (inherited from GlobalPicklistValue)}
#'  \item{allowEmail}{a character either 'true' or 'false'}
#'  \item{closed}{a character either 'true' or 'false'}
#'  \item{controllingFieldValues}{a character}
#'  \item{converted}{a character either 'true' or 'false'}
#'  \item{cssExposed}{a character either 'true' or 'false'}
#'  \item{forecastCategory}{a ForecastCategories - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Omitted}
#'      \item{Pipeline}
#'      \item{BestCase}
#'      \item{Forecast}
#'      \item{Closed}
#'    }
#'   }
#'  \item{highPriority}{a character either 'true' or 'false'}
#'  \item{probability}{an integer}
#'  \item{reverseRole}{a character}
#'  \item{reviewed}{a character either 'true' or 'false'}
#'  \item{won}{a character either 'true' or 'false'}
#' }
#'
#' \strong{PicklistValueTranslation}
#'
#' \describe{
#'  \item{masterLabel}{a character}
#'  \item{translation}{a character}
#' }
#'
#' \strong{PlatformActionList}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{actionListContext}{a PlatformActionListContext - which is a character taking one of the following values:
#'    \itemize{
#'      \item{ListView}
#'      \item{RelatedList}
#'      \item{ListViewRecord}
#'      \item{RelatedListRecord}
#'      \item{Record}
#'      \item{FeedElement}
#'      \item{Chatter}
#'      \item{Global}
#'      \item{Flexipage}
#'      \item{MruList}
#'      \item{MruRow}
#'      \item{RecordEdit}
#'      \item{Photo}
#'      \item{BannerPhoto}
#'      \item{ObjectHomeChart}
#'      \item{ListViewDefinition}
#'      \item{Dockable}
#'      \item{Lookup}
#'      \item{Assistant}
#'    }
#'   }
#'  \item{platformActionListItems}{a PlatformActionListItem}
#'  \item{relatedSourceEntity}{a character}
#' }
#'
#' \strong{PlatformActionListItem}
#'
#' \describe{
#'  \item{actionName}{a character}
#'  \item{actionType}{a PlatformActionType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{QuickAction}
#'      \item{StandardButton}
#'      \item{CustomButton}
#'      \item{ProductivityAction}
#'      \item{ActionLink}
#'      \item{InvocableAction}
#'    }
#'   }
#'  \item{sortOrder}{an integer}
#'  \item{subtype}{a character}
#' }
#'
#' \strong{PlatformCachePartition}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{description}{a character}
#'  \item{isDefaultPartition}{a character either 'true' or 'false'}
#'  \item{masterLabel}{a character}
#'  \item{platformCachePartitionTypes}{a PlatformCachePartitionType}
#' }
#'
#' \strong{PlatformCachePartitionType}
#'
#' \describe{
#'  \item{allocatedCapacity}{an integer}
#'  \item{allocatedPurchasedCapacity}{an integer}
#'  \item{allocatedTrialCapacity}{an integer}
#'  \item{cacheType}{a PlatformCacheType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Session}
#'      \item{Organization}
#'    }
#'   }
#' }
#'
#' \strong{Portal}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{active}{a character either 'true' or 'false'}
#'  \item{admin}{a character}
#'  \item{defaultLanguage}{a character}
#'  \item{description}{a character}
#'  \item{emailSenderAddress}{a character}
#'  \item{emailSenderName}{a character}
#'  \item{enableSelfCloseCase}{a character either 'true' or 'false'}
#'  \item{footerDocument}{a character}
#'  \item{forgotPassTemplate}{a character}
#'  \item{headerDocument}{a character}
#'  \item{isSelfRegistrationActivated}{a character either 'true' or 'false'}
#'  \item{loginHeaderDocument}{a character}
#'  \item{logoDocument}{a character}
#'  \item{logoutUrl}{a character}
#'  \item{newCommentTemplate}{a character}
#'  \item{newPassTemplate}{a character}
#'  \item{newUserTemplate}{a character}
#'  \item{ownerNotifyTemplate}{a character}
#'  \item{selfRegNewUserUrl}{a character}
#'  \item{selfRegUserDefaultProfile}{a character}
#'  \item{selfRegUserDefaultRole}{a PortalRoles - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Executive}
#'      \item{Manager}
#'      \item{Worker}
#'      \item{PersonAccount}
#'    }
#'   }
#'  \item{selfRegUserTemplate}{a character}
#'  \item{showActionConfirmation}{a character either 'true' or 'false'}
#'  \item{stylesheetDocument}{a character}
#'  \item{type}{a PortalType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{CustomerSuccess}
#'      \item{Partner}
#'      \item{Network}
#'    }
#'   }
#' }
#'
#' \strong{PostTemplate}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{default}{a character either 'true' or 'false'}
#'  \item{description}{a character}
#'  \item{fields}{a character}
#'  \item{label}{a character}
#' }
#'
#' \strong{PrimaryTabComponents}
#'
#' \describe{
#'  \item{containers}{a Container}
#' }
#'
#' \strong{ProductSettings}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{enableCascadeActivateToRelatedPrices}{a character either 'true' or 'false'}
#'  \item{enableQuantitySchedule}{a character either 'true' or 'false'}
#'  \item{enableRevenueSchedule}{a character either 'true' or 'false'}
#' }
#'
#' \strong{Profile}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{applicationVisibilities}{a ProfileApplicationVisibility}
#'  \item{categoryGroupVisibilities}{a ProfileCategoryGroupVisibility}
#'  \item{classAccesses}{a ProfileApexClassAccess}
#'  \item{custom}{a character either 'true' or 'false'}
#'  \item{customPermissions}{a ProfileCustomPermissions}
#'  \item{description}{a character}
#'  \item{externalDataSourceAccesses}{a ProfileExternalDataSourceAccess}
#'  \item{fieldPermissions}{a ProfileFieldLevelSecurity}
#'  \item{layoutAssignments}{a ProfileLayoutAssignment}
#'  \item{loginHours}{a ProfileLoginHours}
#'  \item{loginIpRanges}{a ProfileLoginIpRange}
#'  \item{objectPermissions}{a ProfileObjectPermissions}
#'  \item{pageAccesses}{a ProfileApexPageAccess}
#'  \item{profileActionOverrides}{a ProfileActionOverride}
#'  \item{recordTypeVisibilities}{a ProfileRecordTypeVisibility}
#'  \item{tabVisibilities}{a ProfileTabVisibility}
#'  \item{userLicense}{a character}
#'  \item{userPermissions}{a ProfileUserPermission}
#' }
#'
#' \strong{ProfileActionOverride}
#'
#' \describe{
#'  \item{actionName}{a character}
#'  \item{content}{a character}
#'  \item{formFactor}{a FormFactor - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Small}
#'      \item{Medium}
#'      \item{Large}
#'    }
#'   }
#'  \item{pageOrSobjectType}{a character}
#'  \item{recordType}{a character}
#'  \item{type}{a ActionOverrideType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Default}
#'      \item{Standard}
#'      \item{Scontrol}
#'      \item{Visualforce}
#'      \item{Flexipage}
#'      \item{LightningComponent}
#'    }
#'   }
#' }
#'
#' \strong{ProfileApexClassAccess}
#'
#' \describe{
#'  \item{apexClass}{a character}
#'  \item{enabled}{a character either 'true' or 'false'}
#' }
#'
#' \strong{ProfileApexPageAccess}
#'
#' \describe{
#'  \item{apexPage}{a character}
#'  \item{enabled}{a character either 'true' or 'false'}
#' }
#'
#' \strong{ProfileApplicationVisibility}
#'
#' \describe{
#'  \item{application}{a character}
#'  \item{default}{a character either 'true' or 'false'}
#'  \item{visible}{a character either 'true' or 'false'}
#' }
#'
#' \strong{ProfileCategoryGroupVisibility}
#'
#' \describe{
#'  \item{dataCategories}{a character}
#'  \item{dataCategoryGroup}{a character}
#'  \item{visibility}{a CategoryGroupVisibility - which is a character taking one of the following values:
#'    \itemize{
#'      \item{ALL}
#'      \item{NONE}
#'      \item{CUSTOM}
#'    }
#'   }
#' }
#'
#' \strong{ProfileCustomPermissions}
#'
#' \describe{
#'  \item{enabled}{a character either 'true' or 'false'}
#'  \item{name}{a character}
#' }
#'
#' \strong{ProfileExternalDataSourceAccess}
#'
#' \describe{
#'  \item{enabled}{a character either 'true' or 'false'}
#'  \item{externalDataSource}{a character}
#' }
#'
#' \strong{ProfileFieldLevelSecurity}
#'
#' \describe{
#'  \item{editable}{a character either 'true' or 'false'}
#'  \item{field}{a character}
#'  \item{readable}{a character either 'true' or 'false'}
#' }
#'
#' \strong{ProfileLayoutAssignment}
#'
#' \describe{
#'  \item{layout}{a character}
#'  \item{recordType}{a character}
#' }
#'
#' \strong{ProfileLoginHours}
#'
#' \describe{
#'  \item{fridayEnd}{a character}
#'  \item{fridayStart}{a character}
#'  \item{mondayEnd}{a character}
#'  \item{mondayStart}{a character}
#'  \item{saturdayEnd}{a character}
#'  \item{saturdayStart}{a character}
#'  \item{sundayEnd}{a character}
#'  \item{sundayStart}{a character}
#'  \item{thursdayEnd}{a character}
#'  \item{thursdayStart}{a character}
#'  \item{tuesdayEnd}{a character}
#'  \item{tuesdayStart}{a character}
#'  \item{wednesdayEnd}{a character}
#'  \item{wednesdayStart}{a character}
#' }
#'
#' \strong{ProfileLoginIpRange}
#'
#' \describe{
#'  \item{description}{a character}
#'  \item{endAddress}{a character}
#'  \item{startAddress}{a character}
#' }
#'
#' \strong{ProfileObjectPermissions}
#'
#' \describe{
#'  \item{allowCreate}{a character either 'true' or 'false'}
#'  \item{allowDelete}{a character either 'true' or 'false'}
#'  \item{allowEdit}{a character either 'true' or 'false'}
#'  \item{allowRead}{a character either 'true' or 'false'}
#'  \item{modifyAllRecords}{a character either 'true' or 'false'}
#'  \item{object}{a character}
#'  \item{viewAllRecords}{a character either 'true' or 'false'}
#' }
#'
#' \strong{ProfilePasswordPolicy}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{lockoutInterval}{an integer}
#'  \item{maxLoginAttempts}{an integer}
#'  \item{minimumPasswordLength}{an integer}
#'  \item{minimumPasswordLifetime}{a character either 'true' or 'false'}
#'  \item{obscure}{a character either 'true' or 'false'}
#'  \item{passwordComplexity}{an integer}
#'  \item{passwordExpiration}{an integer}
#'  \item{passwordHistory}{an integer}
#'  \item{passwordQuestion}{an integer}
#'  \item{profile}{a character}
#' }
#'
#' \strong{ProfileRecordTypeVisibility}
#'
#' \describe{
#'  \item{default}{a character either 'true' or 'false'}
#'  \item{personAccountDefault}{a character either 'true' or 'false'}
#'  \item{recordType}{a character}
#'  \item{visible}{a character either 'true' or 'false'}
#' }
#'
#' \strong{ProfileSessionSetting}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{externalCommunityUserIdentityVerif}{a character either 'true' or 'false'}
#'  \item{forceLogout}{a character either 'true' or 'false'}
#'  \item{profile}{a character}
#'  \item{requiredSessionLevel}{a SessionSecurityLevel - which is a character taking one of the following values:
#'    \itemize{
#'      \item{LOW}
#'      \item{STANDARD}
#'      \item{HIGH_ASSURANCE}
#'    }
#'   }
#'  \item{sessionPersistence}{a character either 'true' or 'false'}
#'  \item{sessionTimeout}{an integer}
#'  \item{sessionTimeoutWarning}{a character either 'true' or 'false'}
#' }
#'
#' \strong{ProfileTabVisibility}
#'
#' \describe{
#'  \item{tab}{a character}
#'  \item{visibility}{a TabVisibility - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Hidden}
#'      \item{DefaultOff}
#'      \item{DefaultOn}
#'    }
#'   }
#' }
#'
#' \strong{ProfileUserPermission}
#'
#' \describe{
#'  \item{enabled}{a character either 'true' or 'false'}
#'  \item{name}{a character}
#' }
#'
#' \strong{PublicGroups}
#'
#' \describe{
#'  \item{publicGroup}{a character}
#' }
#'
#' \strong{PushNotification}
#'
#' \describe{
#'  \item{fieldNames}{a character}
#'  \item{objectName}{a character}
#' }
#'
#' \strong{Queue}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{doesSendEmailToMembers}{a character either 'true' or 'false'}
#'  \item{email}{a character}
#'  \item{name}{a character}
#'  \item{queueMembers}{a QueueMembers}
#'  \item{queueRoutingConfig}{a character}
#'  \item{queueSobject}{a QueueSobject}
#' }
#'
#' \strong{QueueMembers}
#'
#' \describe{
#'  \item{publicGroups}{a PublicGroups}
#'  \item{roleAndSubordinates}{a RoleAndSubordinates}
#'  \item{roleAndSubordinatesInternal}{a RoleAndSubordinatesInternal}
#'  \item{roles}{a Roles}
#'  \item{users}{a Users}
#' }
#'
#' \strong{QueueSobject}
#'
#' \describe{
#'  \item{sobjectType}{a character}
#' }
#'
#' \strong{QuickAction}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{canvas}{a character}
#'  \item{description}{a character}
#'  \item{fieldOverrides}{a FieldOverride}
#'  \item{flowDefinition}{a character}
#'  \item{height}{an integer}
#'  \item{icon}{a character}
#'  \item{isProtected}{a character either 'true' or 'false'}
#'  \item{label}{a character}
#'  \item{lightningComponent}{a character}
#'  \item{optionsCreateFeedItem}{a character either 'true' or 'false'}
#'  \item{page}{a character}
#'  \item{quickActionLayout}{a QuickActionLayout}
#'  \item{quickActionSendEmailOptions}{a QuickActionSendEmailOptions}
#'  \item{standardLabel}{a QuickActionLabel - which is a character taking one of the following values:
#'    \itemize{
#'      \item{LogACall}
#'      \item{LogANote}
#'      \item{New}
#'      \item{NewRecordType}
#'      \item{Update}
#'      \item{NewChild}
#'      \item{NewChildRecordType}
#'      \item{CreateNew}
#'      \item{CreateNewRecordType}
#'      \item{SendEmail}
#'      \item{QuickRecordType}
#'      \item{Quick}
#'      \item{EditDescription}
#'      \item{Defer}
#'      \item{ChangeDueDate}
#'      \item{ChangePriority}
#'      \item{ChangeStatus}
#'      \item{SocialPost}
#'      \item{Escalate}
#'      \item{EscalateToRecord}
#'      \item{OfferFeedback}
#'      \item{RequestFeedback}
#'      \item{AddRecord}
#'      \item{AddMember}
#'      \item{Reply}
#'      \item{ReplyAll}
#'      \item{Forward}
#'    }
#'   }
#'  \item{successMessage}{a character}
#'  \item{targetObject}{a character}
#'  \item{targetParentField}{a character}
#'  \item{targetRecordType}{a character}
#'  \item{type}{a QuickActionType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Create}
#'      \item{VisualforcePage}
#'      \item{Post}
#'      \item{SendEmail}
#'      \item{LogACall}
#'      \item{SocialPost}
#'      \item{Canvas}
#'      \item{Update}
#'      \item{LightningComponent}
#'      \item{Flow}
#'    }
#'   }
#'  \item{width}{an integer}
#' }
#'
#' \strong{QuickActionLayout}
#'
#' \describe{
#'  \item{layoutSectionStyle}{a LayoutSectionStyle - which is a character taking one of the following values:
#'    \itemize{
#'      \item{TwoColumnsTopToBottom}
#'      \item{TwoColumnsLeftToRight}
#'      \item{OneColumn}
#'      \item{CustomLinks}
#'    }
#'   }
#'  \item{quickActionLayoutColumns}{a QuickActionLayoutColumn}
#' }
#'
#' \strong{QuickActionLayoutColumn}
#'
#' \describe{
#'  \item{quickActionLayoutItems}{a QuickActionLayoutItem}
#' }
#'
#' \strong{QuickActionLayoutItem}
#'
#' \describe{
#'  \item{emptySpace}{a character either 'true' or 'false'}
#'  \item{field}{a character}
#'  \item{uiBehavior}{a UiBehavior - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Edit}
#'      \item{Required}
#'      \item{Readonly}
#'    }
#'   }
#' }
#'
#' \strong{QuickActionList}
#'
#' \describe{
#'  \item{quickActionListItems}{a QuickActionListItem}
#' }
#'
#' \strong{QuickActionListItem}
#'
#' \describe{
#'  \item{quickActionName}{a character}
#' }
#'
#' \strong{QuickActionSendEmailOptions}
#'
#' \describe{
#'  \item{defaultEmailTemplateName}{a character}
#'  \item{ignoreDefaultEmailTemplateSubject}{a character either 'true' or 'false'}
#' }
#'
#' \strong{QuickActionTranslation}
#'
#' \describe{
#'  \item{label}{a character}
#'  \item{name}{a character}
#' }
#'
#' \strong{QuotasSettings}
#'
#' \describe{
#'  \item{showQuotas}{a character either 'true' or 'false'}
#' }
#'
#' \strong{QuoteSettings}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{enableQuote}{a character either 'true' or 'false'}
#' }
#'
#' \strong{RecommendationAudience}
#'
#' \describe{
#'  \item{recommendationAudienceDetails}{a RecommendationAudienceDetail}
#' }
#'
#' \strong{RecommendationAudienceDetail}
#'
#' \describe{
#'  \item{audienceCriteriaType}{a AudienceCriteriaType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{CustomList}
#'      \item{MaxDaysInCommunity}
#'    }
#'   }
#'  \item{audienceCriteriaValue}{a character}
#'  \item{setupName}{a character}
#' }
#'
#' \strong{RecommendationDefinition}
#'
#' \describe{
#'  \item{recommendationDefinitionDetails}{a RecommendationDefinitionDetail}
#' }
#'
#' \strong{RecommendationDefinitionDetail}
#'
#' \describe{
#'  \item{actionUrl}{a character}
#'  \item{description}{a character}
#'  \item{linkText}{a character}
#'  \item{scheduledRecommendations}{a ScheduledRecommendation}
#'  \item{setupName}{a character}
#'  \item{title}{a character}
#' }
#'
#' \strong{RecommendationStrategy}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{description}{a character}
#'  \item{masterLabel}{a character}
#'  \item{recommendationStrategyName}{a character}
#'  \item{strategyNode}{a StrategyNode}
#' }
#'
#' \strong{RecordType}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{active}{a character either 'true' or 'false'}
#'  \item{businessProcess}{a character}
#'  \item{compactLayoutAssignment}{a character}
#'  \item{description}{a character}
#'  \item{label}{a character}
#'  \item{picklistValues}{a RecordTypePicklistValue}
#' }
#'
#' \strong{RecordTypePicklistValue}
#'
#' \describe{
#'  \item{picklist}{a character}
#'  \item{values}{a PicklistValue}
#' }
#'
#' \strong{RecordTypeTranslation}
#'
#' \describe{
#'  \item{description}{a character}
#'  \item{label}{a character}
#'  \item{name}{a character}
#' }
#'
#' \strong{RelatedContent}
#'
#' \describe{
#'  \item{relatedContentItems}{a RelatedContentItem}
#' }
#'
#' \strong{RelatedContentItem}
#'
#' \describe{
#'  \item{layoutItem}{a LayoutItem}
#' }
#'
#' \strong{RelatedList}
#'
#' \describe{
#'  \item{hideOnDetail}{a character either 'true' or 'false'}
#'  \item{name}{a character}
#' }
#'
#' \strong{RelatedListItem}
#'
#' \describe{
#'  \item{customButtons}{a character}
#'  \item{excludeButtons}{a character}
#'  \item{fields}{a character}
#'  \item{relatedList}{a character}
#'  \item{sortField}{a character}
#'  \item{sortOrder}{a SortOrder - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Asc}
#'      \item{Desc}
#'    }
#'   }
#' }
#'
#' \strong{RemoteSiteSetting}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{description}{a character}
#'  \item{disableProtocolSecurity}{a character either 'true' or 'false'}
#'  \item{isActive}{a character either 'true' or 'false'}
#'  \item{url}{a character}
#' }
#'
#' \strong{Report}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{aggregates}{a ReportAggregate}
#'  \item{block}{a Report}
#'  \item{blockInfo}{a ReportBlockInfo}
#'  \item{buckets}{a ReportBucketField}
#'  \item{chart}{a ReportChart}
#'  \item{colorRanges}{a ReportColorRange}
#'  \item{columns}{a ReportColumn}
#'  \item{crossFilters}{a ReportCrossFilter}
#'  \item{currency}{a CurrencyIsoCode - which is a character taking one of the following values:
#'    \itemize{
#'      \item{ADP}
#'      \item{AED}
#'      \item{AFA}
#'      \item{AFN}
#'      \item{ALL}
#'      \item{AMD}
#'      \item{ANG}
#'      \item{AOA}
#'      \item{ARS}
#'      \item{ATS}
#'      \item{AUD}
#'      \item{AWG}
#'      \item{AZM}
#'      \item{AZN}
#'      \item{BAM}
#'      \item{BBD}
#'      \item{BDT}
#'      \item{BEF}
#'      \item{BGL}
#'      \item{BGN}
#'      \item{BHD}
#'      \item{BIF}
#'      \item{BMD}
#'      \item{BND}
#'      \item{BOB}
#'      \item{BOV}
#'      \item{BRB}
#'      \item{BRL}
#'      \item{BSD}
#'      \item{BTN}
#'      \item{BWP}
#'      \item{BYB}
#'      \item{BYN}
#'      \item{BYR}
#'      \item{BZD}
#'      \item{CAD}
#'      \item{CDF}
#'      \item{CHF}
#'      \item{CLF}
#'      \item{CLP}
#'      \item{CNY}
#'      \item{COP}
#'      \item{CRC}
#'      \item{CSD}
#'      \item{CUC}
#'      \item{CUP}
#'      \item{CVE}
#'      \item{CYP}
#'      \item{CZK}
#'      \item{DEM}
#'      \item{DJF}
#'      \item{DKK}
#'      \item{DOP}
#'      \item{DZD}
#'      \item{ECS}
#'      \item{EEK}
#'      \item{EGP}
#'      \item{ERN}
#'      \item{ESP}
#'      \item{ETB}
#'      \item{EUR}
#'      \item{FIM}
#'      \item{FJD}
#'      \item{FKP}
#'      \item{FRF}
#'      \item{GBP}
#'      \item{GEL}
#'      \item{GHC}
#'      \item{GHS}
#'      \item{GIP}
#'      \item{GMD}
#'      \item{GNF}
#'      \item{GRD}
#'      \item{GTQ}
#'      \item{GWP}
#'      \item{GYD}
#'      \item{HKD}
#'      \item{HNL}
#'      \item{HRD}
#'      \item{HRK}
#'      \item{HTG}
#'      \item{HUF}
#'      \item{IDR}
#'      \item{IEP}
#'      \item{ILS}
#'      \item{INR}
#'      \item{IQD}
#'      \item{IRR}
#'      \item{ISK}
#'      \item{ITL}
#'      \item{JMD}
#'      \item{JOD}
#'      \item{JPY}
#'      \item{KES}
#'      \item{KGS}
#'      \item{KHR}
#'      \item{KMF}
#'      \item{KPW}
#'      \item{KRW}
#'      \item{KWD}
#'      \item{KYD}
#'      \item{KZT}
#'      \item{LAK}
#'      \item{LBP}
#'      \item{LKR}
#'      \item{LRD}
#'      \item{LSL}
#'      \item{LTL}
#'      \item{LUF}
#'      \item{LVL}
#'      \item{LYD}
#'      \item{MAD}
#'      \item{MDL}
#'      \item{MGA}
#'      \item{MGF}
#'      \item{MKD}
#'      \item{MMK}
#'      \item{MNT}
#'      \item{MOP}
#'      \item{MRO}
#'      \item{MTL}
#'      \item{MUR}
#'      \item{MVR}
#'      \item{MWK}
#'      \item{MXN}
#'      \item{MXV}
#'      \item{MYR}
#'      \item{MZM}
#'      \item{MZN}
#'      \item{NAD}
#'      \item{NGN}
#'      \item{NIO}
#'      \item{NLG}
#'      \item{NOK}
#'      \item{NPR}
#'      \item{NZD}
#'      \item{OMR}
#'      \item{PAB}
#'      \item{PEN}
#'      \item{PGK}
#'      \item{PHP}
#'      \item{PKR}
#'      \item{PLN}
#'      \item{PTE}
#'      \item{PYG}
#'      \item{QAR}
#'      \item{RMB}
#'      \item{ROL}
#'      \item{RON}
#'      \item{RSD}
#'      \item{RUB}
#'      \item{RUR}
#'      \item{RWF}
#'      \item{SAR}
#'      \item{SBD}
#'      \item{SCR}
#'      \item{SDD}
#'      \item{SDG}
#'      \item{SEK}
#'      \item{SGD}
#'      \item{SHP}
#'      \item{SIT}
#'      \item{SKK}
#'      \item{SLL}
#'      \item{SOS}
#'      \item{SRD}
#'      \item{SRG}
#'      \item{SSP}
#'      \item{STD}
#'      \item{SUR}
#'      \item{SVC}
#'      \item{SYP}
#'      \item{SZL}
#'      \item{THB}
#'      \item{TJR}
#'      \item{TJS}
#'      \item{TMM}
#'      \item{TMT}
#'      \item{TND}
#'      \item{TOP}
#'      \item{TPE}
#'      \item{TRL}
#'      \item{TRY}
#'      \item{TTD}
#'      \item{TWD}
#'      \item{TZS}
#'      \item{UAH}
#'      \item{UGX}
#'      \item{USD}
#'      \item{UYU}
#'      \item{UZS}
#'      \item{VEB}
#'      \item{VEF}
#'      \item{VND}
#'      \item{VUV}
#'      \item{WST}
#'      \item{XAF}
#'      \item{XCD}
#'      \item{XOF}
#'      \item{XPF}
#'      \item{YER}
#'      \item{YUM}
#'      \item{ZAR}
#'      \item{ZMK}
#'      \item{ZMW}
#'      \item{ZWD}
#'      \item{ZWL}
#'    }
#'   }
#'  \item{dataCategoryFilters}{a ReportDataCategoryFilter}
#'  \item{description}{a character}
#'  \item{division}{a character}
#'  \item{filter}{a ReportFilter}
#'  \item{folderName}{a character}
#'  \item{format}{a ReportFormat - which is a character taking one of the following values:
#'    \itemize{
#'      \item{MultiBlock}
#'      \item{Matrix}
#'      \item{Summary}
#'      \item{Tabular}
#'    }
#'   }
#'  \item{groupingsAcross}{a ReportGrouping}
#'  \item{groupingsDown}{a ReportGrouping}
#'  \item{historicalSelector}{a ReportHistoricalSelector}
#'  \item{name}{a character}
#'  \item{numSubscriptions}{an integer}
#'  \item{params}{a ReportParam}
#'  \item{reportType}{a character}
#'  \item{roleHierarchyFilter}{a character}
#'  \item{rowLimit}{an integer}
#'  \item{scope}{a character}
#'  \item{showCurrentDate}{a character either 'true' or 'false'}
#'  \item{showDetails}{a character either 'true' or 'false'}
#'  \item{sortColumn}{a character}
#'  \item{sortOrder}{a SortOrder - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Asc}
#'      \item{Desc}
#'    }
#'   }
#'  \item{territoryHierarchyFilter}{a character}
#'  \item{timeFrameFilter}{a ReportTimeFrameFilter}
#'  \item{userFilter}{a character}
#' }
#'
#' \strong{ReportAggregate}
#'
#' \describe{
#'  \item{acrossGroupingContext}{a character}
#'  \item{calculatedFormula}{a character}
#'  \item{datatype}{a ReportAggregateDatatype - which is a character taking one of the following values:
#'    \itemize{
#'      \item{currency}
#'      \item{percent}
#'      \item{number}
#'    }
#'   }
#'  \item{description}{a character}
#'  \item{developerName}{a character}
#'  \item{downGroupingContext}{a character}
#'  \item{isActive}{a character either 'true' or 'false'}
#'  \item{isCrossBlock}{a character either 'true' or 'false'}
#'  \item{masterLabel}{a character}
#'  \item{reportType}{a character}
#'  \item{scale}{an integer}
#' }
#'
#' \strong{ReportAggregateReference}
#'
#' \describe{
#'  \item{aggregate}{a character}
#' }
#'
#' \strong{ReportBlockInfo}
#'
#' \describe{
#'  \item{aggregateReferences}{a ReportAggregateReference}
#'  \item{blockId}{a character}
#'  \item{joinTable}{a character}
#' }
#'
#' \strong{ReportBucketField}
#'
#' \describe{
#'  \item{bucketType}{a ReportBucketFieldType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{text}
#'      \item{number}
#'      \item{picklist}
#'    }
#'   }
#'  \item{developerName}{a character}
#'  \item{masterLabel}{a character}
#'  \item{nullTreatment}{a ReportFormulaNullTreatment - which is a character taking one of the following values:
#'    \itemize{
#'      \item{n}
#'      \item{z}
#'    }
#'   }
#'  \item{otherBucketLabel}{a character}
#'  \item{sourceColumnName}{a character}
#'  \item{useOther}{a character either 'true' or 'false'}
#'  \item{values}{a ReportBucketFieldValue}
#' }
#'
#' \strong{ReportBucketFieldSourceValue}
#'
#' \describe{
#'  \item{from}{a character}
#'  \item{sourceValue}{a character}
#'  \item{to}{a character}
#' }
#'
#' \strong{ReportBucketFieldValue}
#'
#' \describe{
#'  \item{sourceValues}{a ReportBucketFieldSourceValue}
#'  \item{value}{a character}
#' }
#'
#' \strong{ReportChart}
#'
#' \describe{
#'  \item{backgroundColor1}{a character}
#'  \item{backgroundColor2}{a character}
#'  \item{backgroundFadeDir}{a ChartBackgroundDirection - which is a character taking one of the following values:
#'    \itemize{
#'      \item{TopToBottom}
#'      \item{LeftToRight}
#'      \item{Diagonal}
#'    }
#'   }
#'  \item{chartSummaries}{a ChartSummary}
#'  \item{chartType}{a ChartType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{None}
#'      \item{Scatter}
#'      \item{ScatterGrouped}
#'      \item{Bubble}
#'      \item{BubbleGrouped}
#'      \item{HorizontalBar}
#'      \item{HorizontalBarGrouped}
#'      \item{HorizontalBarStacked}
#'      \item{HorizontalBarStackedTo100}
#'      \item{VerticalColumn}
#'      \item{VerticalColumnGrouped}
#'      \item{VerticalColumnStacked}
#'      \item{VerticalColumnStackedTo100}
#'      \item{Line}
#'      \item{LineGrouped}
#'      \item{LineCumulative}
#'      \item{LineCumulativeGrouped}
#'      \item{Pie}
#'      \item{Donut}
#'      \item{Funnel}
#'      \item{VerticalColumnLine}
#'      \item{VerticalColumnGroupedLine}
#'      \item{VerticalColumnStackedLine}
#'      \item{Plugin}
#'    }
#'   }
#'  \item{enableHoverLabels}{a character either 'true' or 'false'}
#'  \item{expandOthers}{a character either 'true' or 'false'}
#'  \item{groupingColumn}{a character}
#'  \item{legendPosition}{a ChartLegendPosition - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Right}
#'      \item{Bottom}
#'      \item{OnChart}
#'    }
#'   }
#'  \item{location}{a ChartPosition - which is a character taking one of the following values:
#'    \itemize{
#'      \item{CHART_TOP}
#'      \item{CHART_BOTTOM}
#'    }
#'   }
#'  \item{secondaryGroupingColumn}{a character}
#'  \item{showAxisLabels}{a character either 'true' or 'false'}
#'  \item{showPercentage}{a character either 'true' or 'false'}
#'  \item{showTotal}{a character either 'true' or 'false'}
#'  \item{showValues}{a character either 'true' or 'false'}
#'  \item{size}{a ReportChartSize - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Tiny}
#'      \item{Small}
#'      \item{Medium}
#'      \item{Large}
#'      \item{Huge}
#'    }
#'   }
#'  \item{summaryAxisManualRangeEnd}{a numeric}
#'  \item{summaryAxisManualRangeStart}{a numeric}
#'  \item{summaryAxisRange}{a ChartRangeType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Auto}
#'      \item{Manual}
#'    }
#'   }
#'  \item{textColor}{a character}
#'  \item{textSize}{an integer}
#'  \item{title}{a character}
#'  \item{titleColor}{a character}
#'  \item{titleSize}{an integer}
#' }
#'
#' \strong{ReportChartComponentLayoutItem}
#'
#' \describe{
#'  \item{cacheData}{a character either 'true' or 'false'}
#'  \item{contextFilterableField}{a character}
#'  \item{error}{a character}
#'  \item{hideOnError}{a character either 'true' or 'false'}
#'  \item{includeContext}{a character either 'true' or 'false'}
#'  \item{reportName}{a character}
#'  \item{showTitle}{a character either 'true' or 'false'}
#'  \item{size}{a ReportChartComponentSize - which is a character taking one of the following values:
#'    \itemize{
#'      \item{SMALL}
#'      \item{MEDIUM}
#'      \item{LARGE}
#'    }
#'   }
#' }
#'
#' \strong{ReportColorRange}
#'
#' \describe{
#'  \item{aggregate}{a ReportSummaryType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Sum}
#'      \item{Average}
#'      \item{Maximum}
#'      \item{Minimum}
#'      \item{None}
#'    }
#'   }
#'  \item{columnName}{a character}
#'  \item{highBreakpoint}{a numeric}
#'  \item{highColor}{a character}
#'  \item{lowBreakpoint}{a numeric}
#'  \item{lowColor}{a character}
#'  \item{midColor}{a character}
#' }
#'
#' \strong{ReportColumn}
#'
#' \describe{
#'  \item{aggregateTypes}{a ReportSummaryType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Sum}
#'      \item{Average}
#'      \item{Maximum}
#'      \item{Minimum}
#'      \item{None}
#'    }
#'   }
#'  \item{field}{a character}
#'  \item{reverseColors}{a character either 'true' or 'false'}
#'  \item{showChanges}{a character either 'true' or 'false'}
#' }
#'
#' \strong{ReportCrossFilter}
#'
#' \describe{
#'  \item{criteriaItems}{a ReportFilterItem}
#'  \item{operation}{a ObjectFilterOperator - which is a character taking one of the following values:
#'    \itemize{
#'      \item{with}
#'      \item{without}
#'    }
#'   }
#'  \item{primaryTableColumn}{a character}
#'  \item{relatedTable}{a character}
#'  \item{relatedTableJoinColumn}{a character}
#' }
#'
#' \strong{ReportDataCategoryFilter}
#'
#' \describe{
#'  \item{dataCategory}{a character}
#'  \item{dataCategoryGroup}{a character}
#'  \item{operator}{a DataCategoryFilterOperation - which is a character taking one of the following values:
#'    \itemize{
#'      \item{above}
#'      \item{below}
#'      \item{at}
#'      \item{aboveOrBelow}
#'    }
#'   }
#' }
#'
#' \strong{ReportFilter}
#'
#' \describe{
#'  \item{booleanFilter}{a character}
#'  \item{criteriaItems}{a ReportFilterItem}
#'  \item{language}{a Language - which is a character taking one of the following values:
#'    \itemize{
#'      \item{en_US}
#'      \item{de}
#'      \item{es}
#'      \item{fr}
#'      \item{it}
#'      \item{ja}
#'      \item{sv}
#'      \item{ko}
#'      \item{zh_TW}
#'      \item{zh_CN}
#'      \item{pt_BR}
#'      \item{nl_NL}
#'      \item{da}
#'      \item{th}
#'      \item{fi}
#'      \item{ru}
#'      \item{es_MX}
#'      \item{no}
#'      \item{hu}
#'      \item{pl}
#'      \item{cs}
#'      \item{tr}
#'      \item{in}
#'      \item{ro}
#'      \item{vi}
#'      \item{uk}
#'      \item{iw}
#'      \item{el}
#'      \item{bg}
#'      \item{en_GB}
#'      \item{ar}
#'      \item{sk}
#'      \item{pt_PT}
#'      \item{hr}
#'      \item{sl}
#'      \item{fr_CA}
#'      \item{ka}
#'      \item{sr}
#'      \item{sh}
#'      \item{en_AU}
#'      \item{en_MY}
#'      \item{en_IN}
#'      \item{en_PH}
#'      \item{en_CA}
#'      \item{ro_MD}
#'      \item{bs}
#'      \item{mk}
#'      \item{lv}
#'      \item{lt}
#'      \item{et}
#'      \item{sq}
#'      \item{sh_ME}
#'      \item{mt}
#'      \item{ga}
#'      \item{eu}
#'      \item{cy}
#'      \item{is}
#'      \item{ms}
#'      \item{tl}
#'      \item{lb}
#'      \item{rm}
#'      \item{hy}
#'      \item{hi}
#'      \item{ur}
#'      \item{bn}
#'      \item{de_AT}
#'      \item{de_CH}
#'      \item{ta}
#'      \item{ar_DZ}
#'      \item{ar_BH}
#'      \item{ar_EG}
#'      \item{ar_IQ}
#'      \item{ar_JO}
#'      \item{ar_KW}
#'      \item{ar_LB}
#'      \item{ar_LY}
#'      \item{ar_MA}
#'      \item{ar_OM}
#'      \item{ar_QA}
#'      \item{ar_SA}
#'      \item{ar_SD}
#'      \item{ar_SY}
#'      \item{ar_TN}
#'      \item{ar_AE}
#'      \item{ar_YE}
#'      \item{zh_SG}
#'      \item{zh_HK}
#'      \item{en_HK}
#'      \item{en_IE}
#'      \item{en_SG}
#'      \item{en_ZA}
#'      \item{fr_BE}
#'      \item{fr_LU}
#'      \item{fr_CH}
#'      \item{de_BE}
#'      \item{de_LU}
#'      \item{it_CH}
#'      \item{nl_BE}
#'      \item{es_AR}
#'      \item{es_BO}
#'      \item{es_CL}
#'      \item{es_CO}
#'      \item{es_CR}
#'      \item{es_DO}
#'      \item{es_EC}
#'      \item{es_SV}
#'      \item{es_GT}
#'      \item{es_HN}
#'      \item{es_NI}
#'      \item{es_PA}
#'      \item{es_PY}
#'      \item{es_PE}
#'      \item{es_PR}
#'      \item{es_US}
#'      \item{es_UY}
#'      \item{es_VE}
#'      \item{ca}
#'      \item{eo}
#'      \item{iw_EO}
#'    }
#'   }
#' }
#'
#' \strong{ReportFilterItem}
#'
#' \describe{
#'  \item{column}{a character}
#'  \item{columnToColumn}{a character either 'true' or 'false'}
#'  \item{isUnlocked}{a character either 'true' or 'false'}
#'  \item{operator}{a FilterOperation - which is a character taking one of the following values:
#'    \itemize{
#'      \item{equals}
#'      \item{notEqual}
#'      \item{lessThan}
#'      \item{greaterThan}
#'      \item{lessOrEqual}
#'      \item{greaterOrEqual}
#'      \item{contains}
#'      \item{notContain}
#'      \item{startsWith}
#'      \item{includes}
#'      \item{excludes}
#'      \item{within}
#'    }
#'   }
#'  \item{snapshot}{a character}
#'  \item{value}{a character}
#' }
#'
#' \strong{ReportFolder}
#'
#' \describe{
#'  \item{accessType}{a FolderAccessTypes (inherited from Folder)}
#'  \item{folderShares}{a FolderShare (inherited from Folder)}
#'  \item{name}{a character (inherited from Folder)}
#'  \item{publicFolderAccess}{a PublicFolderAccess (inherited from Folder)}
#'  \item{sharedTo}{a SharedTo (inherited from Folder)}
#' }
#'
#' \strong{ReportGrouping}
#'
#' \describe{
#'  \item{aggregateType}{a ReportAggrType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Sum}
#'      \item{Average}
#'      \item{Maximum}
#'      \item{Minimum}
#'      \item{RowCount}
#'    }
#'   }
#'  \item{dateGranularity}{a UserDateGranularity - which is a character taking one of the following values:
#'    \itemize{
#'      \item{None}
#'      \item{Day}
#'      \item{Week}
#'      \item{Month}
#'      \item{Quarter}
#'      \item{Year}
#'      \item{FiscalQuarter}
#'      \item{FiscalYear}
#'      \item{MonthInYear}
#'      \item{DayInMonth}
#'      \item{FiscalPeriod}
#'      \item{FiscalWeek}
#'    }
#'   }
#'  \item{field}{a character}
#'  \item{sortByName}{a character}
#'  \item{sortOrder}{a SortOrder - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Asc}
#'      \item{Desc}
#'    }
#'   }
#'  \item{sortType}{a ReportSortType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Column}
#'      \item{Aggregate}
#'      \item{CustomSummaryFormula}
#'    }
#'   }
#' }
#'
#' \strong{ReportHistoricalSelector}
#'
#' \describe{
#'  \item{snapshot}{a character}
#' }
#'
#' \strong{ReportLayoutSection}
#'
#' \describe{
#'  \item{columns}{a ReportTypeColumn}
#'  \item{masterLabel}{a character}
#' }
#'
#' \strong{ReportParam}
#'
#' \describe{
#'  \item{name}{a character}
#'  \item{value}{a character}
#' }
#'
#' \strong{ReportTimeFrameFilter}
#'
#' \describe{
#'  \item{dateColumn}{a character}
#'  \item{endDate}{a character formatted as 'yyyy-mm-dd'}
#'  \item{interval}{a UserDateInterval - which is a character taking one of the following values:
#'    \itemize{
#'      \item{INTERVAL_CURRENT}
#'      \item{INTERVAL_CURNEXT1}
#'      \item{INTERVAL_CURPREV1}
#'      \item{INTERVAL_NEXT1}
#'      \item{INTERVAL_PREV1}
#'      \item{INTERVAL_CURNEXT3}
#'      \item{INTERVAL_CURFY}
#'      \item{INTERVAL_PREVFY}
#'      \item{INTERVAL_PREV2FY}
#'      \item{INTERVAL_AGO2FY}
#'      \item{INTERVAL_NEXTFY}
#'      \item{INTERVAL_PREVCURFY}
#'      \item{INTERVAL_PREVCUR2FY}
#'      \item{INTERVAL_CURNEXTFY}
#'      \item{INTERVAL_CUSTOM}
#'      \item{INTERVAL_YESTERDAY}
#'      \item{INTERVAL_TODAY}
#'      \item{INTERVAL_TOMORROW}
#'      \item{INTERVAL_LASTWEEK}
#'      \item{INTERVAL_THISWEEK}
#'      \item{INTERVAL_NEXTWEEK}
#'      \item{INTERVAL_LASTMONTH}
#'      \item{INTERVAL_THISMONTH}
#'      \item{INTERVAL_NEXTMONTH}
#'      \item{INTERVAL_LASTTHISMONTH}
#'      \item{INTERVAL_THISNEXTMONTH}
#'      \item{INTERVAL_CURRENTQ}
#'      \item{INTERVAL_CURNEXTQ}
#'      \item{INTERVAL_CURPREVQ}
#'      \item{INTERVAL_NEXTQ}
#'      \item{INTERVAL_PREVQ}
#'      \item{INTERVAL_CURNEXT3Q}
#'      \item{INTERVAL_CURY}
#'      \item{INTERVAL_PREVY}
#'      \item{INTERVAL_PREV2Y}
#'      \item{INTERVAL_AGO2Y}
#'      \item{INTERVAL_NEXTY}
#'      \item{INTERVAL_PREVCURY}
#'      \item{INTERVAL_PREVCUR2Y}
#'      \item{INTERVAL_CURNEXTY}
#'      \item{INTERVAL_LAST7}
#'      \item{INTERVAL_LAST30}
#'      \item{INTERVAL_LAST60}
#'      \item{INTERVAL_LAST90}
#'      \item{INTERVAL_LAST120}
#'      \item{INTERVAL_NEXT7}
#'      \item{INTERVAL_NEXT30}
#'      \item{INTERVAL_NEXT60}
#'      \item{INTERVAL_NEXT90}
#'      \item{INTERVAL_NEXT120}
#'      \item{LAST_FISCALWEEK}
#'      \item{THIS_FISCALWEEK}
#'      \item{NEXT_FISCALWEEK}
#'      \item{LAST_FISCALPERIOD}
#'      \item{THIS_FISCALPERIOD}
#'      \item{NEXT_FISCALPERIOD}
#'      \item{LASTTHIS_FISCALPERIOD}
#'      \item{THISNEXT_FISCALPERIOD}
#'      \item{CURRENT_ENTITLEMENT_PERIOD}
#'      \item{PREVIOUS_ENTITLEMENT_PERIOD}
#'      \item{PREVIOUS_TWO_ENTITLEMENT_PERIODS}
#'      \item{TWO_ENTITLEMENT_PERIODS_AGO}
#'      \item{CURRENT_AND_PREVIOUS_ENTITLEMENT_PERIOD}
#'      \item{CURRENT_AND_PREVIOUS_TWO_ENTITLEMENT_PERIODS}
#'    }
#'   }
#'  \item{startDate}{a character formatted as 'yyyy-mm-dd'}
#' }
#'
#' \strong{ReportType}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{autogenerated}{a character either 'true' or 'false'}
#'  \item{baseObject}{a character}
#'  \item{category}{a ReportTypeCategory - which is a character taking one of the following values:
#'    \itemize{
#'      \item{accounts}
#'      \item{opportunities}
#'      \item{forecasts}
#'      \item{cases}
#'      \item{leads}
#'      \item{campaigns}
#'      \item{activities}
#'      \item{busop}
#'      \item{products}
#'      \item{admin}
#'      \item{territory}
#'      \item{other}
#'      \item{content}
#'      \item{usage_entitlement}
#'      \item{wdc}
#'      \item{calibration}
#'      \item{territory2}
#'    }
#'   }
#'  \item{deployed}{a character either 'true' or 'false'}
#'  \item{description}{a character}
#'  \item{join}{a ObjectRelationship}
#'  \item{label}{a character}
#'  \item{sections}{a ReportLayoutSection}
#' }
#'
#' \strong{ReportTypeColumn}
#'
#' \describe{
#'  \item{checkedByDefault}{a character either 'true' or 'false'}
#'  \item{displayNameOverride}{a character}
#'  \item{field}{a character}
#'  \item{table}{a character}
#' }
#'
#' \strong{ReportTypeColumnTranslation}
#'
#' \describe{
#'  \item{label}{a character}
#'  \item{name}{a character}
#' }
#'
#' \strong{ReportTypeSectionTranslation}
#'
#' \describe{
#'  \item{columns}{a ReportTypeColumnTranslation}
#'  \item{label}{a character}
#'  \item{name}{a character}
#' }
#'
#' \strong{ReportTypeTranslation}
#'
#' \describe{
#'  \item{description}{a character}
#'  \item{label}{a character}
#'  \item{name}{a character}
#'  \item{sections}{a ReportTypeSectionTranslation}
#' }
#'
#' \strong{ReputationBranding}
#'
#' \describe{
#'  \item{smallImage}{a character}
#' }
#'
#' \strong{ReputationLevel}
#'
#' \describe{
#'  \item{branding}{a ReputationBranding}
#'  \item{label}{a character}
#'  \item{lowerThreshold}{a numeric}
#' }
#'
#' \strong{ReputationLevelDefinitions}
#'
#' \describe{
#'  \item{level}{a ReputationLevel}
#' }
#'
#' \strong{ReputationLevels}
#'
#' \describe{
#'  \item{chatterAnswersReputationLevels}{a ChatterAnswersReputationLevel}
#'  \item{ideaReputationLevels}{a IdeaReputationLevel}
#' }
#'
#' \strong{ReputationPointsRule}
#'
#' \describe{
#'  \item{eventType}{a character}
#'  \item{points}{an integer}
#' }
#'
#' \strong{ReputationPointsRules}
#'
#' \describe{
#'  \item{pointsRule}{a ReputationPointsRule}
#' }
#'
#' \strong{RetrieveRequest}
#'
#' \describe{
#'  \item{apiVersion}{a numeric}
#'  \item{packageNames}{a character}
#'  \item{singlePackage}{a character either 'true' or 'false'}
#'  \item{specificFiles}{a character}
#'  \item{unpackaged}{a Package}
#' }
#'
#' \strong{Role}
#'
#' \describe{
#'  \item{caseAccessLevel}{a character (inherited from RoleOrTerritory)}
#'  \item{contactAccessLevel}{a character (inherited from RoleOrTerritory)}
#'  \item{description}{a character (inherited from RoleOrTerritory)}
#'  \item{mayForecastManagerShare}{a character either 'true' or 'false' (inherited from RoleOrTerritory)}
#'  \item{name}{a character (inherited from RoleOrTerritory)}
#'  \item{opportunityAccessLevel}{a character (inherited from RoleOrTerritory)}
#'  \item{parentRole}{a character}
#' }
#'
#' \strong{RoleAndSubordinates}
#'
#' \describe{
#'  \item{roleAndSubordinate}{a character}
#' }
#'
#' \strong{RoleAndSubordinatesInternal}
#'
#' \describe{
#'  \item{roleAndSubordinateInternal}{a character}
#' }
#'
#' \strong{RoleOrTerritory}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{caseAccessLevel}{a character}
#'  \item{contactAccessLevel}{a character}
#'  \item{description}{a character}
#'  \item{mayForecastManagerShare}{a character either 'true' or 'false'}
#'  \item{name}{a character}
#'  \item{opportunityAccessLevel}{a character}
#' }
#'
#' \strong{Roles}
#'
#' \describe{
#'  \item{role}{a character}
#' }
#'
#' \strong{RuleEntry}
#'
#' \describe{
#'  \item{assignedTo}{a character}
#'  \item{assignedToType}{a AssignToLookupValueType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{User}
#'      \item{Queue}
#'    }
#'   }
#'  \item{booleanFilter}{a character}
#'  \item{businessHours}{a character}
#'  \item{businessHoursSource}{a BusinessHoursSourceType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{None}
#'      \item{Case}
#'      \item{Static}
#'    }
#'   }
#'  \item{criteriaItems}{a FilterItem}
#'  \item{disableEscalationWhenModified}{a character either 'true' or 'false'}
#'  \item{escalationAction}{a EscalationAction}
#'  \item{escalationStartTime}{a EscalationStartTimeType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{CaseCreation}
#'      \item{CaseLastModified}
#'    }
#'   }
#'  \item{formula}{a character}
#'  \item{notifyCcRecipients}{a character either 'true' or 'false'}
#'  \item{overrideExistingTeams}{a character either 'true' or 'false'}
#'  \item{replyToEmail}{a character}
#'  \item{senderEmail}{a character}
#'  \item{senderName}{a character}
#'  \item{team}{a character}
#'  \item{template}{a character}
#' }
#'
#' \strong{SamlSsoConfig}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{attributeName}{a character}
#'  \item{attributeNameIdFormat}{a character}
#'  \item{decryptionCertificate}{a character}
#'  \item{errorUrl}{a character}
#'  \item{executionUserId}{a character}
#'  \item{identityLocation}{a SamlIdentityLocationType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{SubjectNameId}
#'      \item{Attribute}
#'    }
#'   }
#'  \item{identityMapping}{a SamlIdentityType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Username}
#'      \item{FederationId}
#'      \item{UserId}
#'    }
#'   }
#'  \item{issuer}{a character}
#'  \item{loginUrl}{a character}
#'  \item{logoutUrl}{a character}
#'  \item{name}{a character}
#'  \item{oauthTokenEndpoint}{a character}
#'  \item{redirectBinding}{a character either 'true' or 'false'}
#'  \item{requestSignatureMethod}{a character}
#'  \item{requestSigningCertId}{a character}
#'  \item{salesforceLoginUrl}{a character}
#'  \item{samlEntityId}{a character}
#'  \item{samlJitHandlerId}{a character}
#'  \item{samlVersion}{a SamlType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{SAML1_1}
#'      \item{SAML2_0}
#'    }
#'   }
#'  \item{singleLogoutBinding}{a SamlSpSLOBinding - which is a character taking one of the following values:
#'    \itemize{
#'      \item{RedirectBinding}
#'      \item{PostBinding}
#'    }
#'   }
#'  \item{singleLogoutUrl}{a character}
#'  \item{userProvisioning}{a character either 'true' or 'false'}
#'  \item{validationCert}{a character}
#' }
#'
#' \strong{ScheduledRecommendation}
#'
#' \describe{
#'  \item{scheduledRecommendationDetails}{a ScheduledRecommendationDetail}
#' }
#'
#' \strong{ScheduledRecommendationDetail}
#'
#' \describe{
#'  \item{channel}{a RecommendationChannel - which is a character taking one of the following values:
#'    \itemize{
#'      \item{DefaultChannel}
#'      \item{CustomChannel1}
#'      \item{CustomChannel2}
#'      \item{CustomChannel3}
#'      \item{CustomChannel4}
#'      \item{CustomChannel5}
#'    }
#'   }
#'  \item{enabled}{a character either 'true' or 'false'}
#'  \item{rank}{an integer}
#'  \item{recommendationAudience}{a character}
#' }
#'
#' \strong{Scontrol}
#'
#' \describe{
#'  \item{content}{a character formed using \code{\link[base64enc]{base64encode}} (inherited from MetadataWithContent)}
#'  \item{contentSource}{a SControlContentSource - which is a character taking one of the following values:
#'    \itemize{
#'      \item{HTML}
#'      \item{URL}
#'      \item{Snippet}
#'    }
#'   }
#'  \item{description}{a character}
#'  \item{encodingKey}{a Encoding - which is a character taking one of the following values:
#'    \itemize{
#'      \item{UTF-8}
#'      \item{ISO-8859-1}
#'      \item{Shift_JIS}
#'      \item{ISO-2022-JP}
#'      \item{EUC-JP}
#'      \item{ks_c_5601-1987}
#'      \item{Big5}
#'      \item{GB2312}
#'      \item{Big5-HKSCS}
#'      \item{x-SJIS_0213}
#'    }
#'   }
#'  \item{fileContent}{a character formed using \code{\link[base64enc]{base64encode}}}
#'  \item{fileName}{a character}
#'  \item{name}{a character}
#'  \item{supportsCaching}{a character either 'true' or 'false'}
#' }
#'
#' \strong{ScontrolTranslation}
#'
#' \describe{
#'  \item{label}{a character}
#'  \item{name}{a character}
#' }
#'
#' \strong{SearchLayouts}
#'
#' \describe{
#'  \item{customTabListAdditionalFields}{a character}
#'  \item{excludedStandardButtons}{a character}
#'  \item{listViewButtons}{a character}
#'  \item{lookupDialogsAdditionalFields}{a character}
#'  \item{lookupFilterFields}{a character}
#'  \item{lookupPhoneDialogsAdditionalFields}{a character}
#'  \item{searchFilterFields}{a character}
#'  \item{searchResultsAdditionalFields}{a character}
#'  \item{searchResultsCustomButtons}{a character}
#' }
#'
#' \strong{SearchSettings}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{documentContentSearchEnabled}{a character either 'true' or 'false'}
#'  \item{optimizeSearchForCJKEnabled}{a character either 'true' or 'false'}
#'  \item{recentlyViewedUsersForBlankLookupEnabled}{a character either 'true' or 'false'}
#'  \item{searchSettingsByObject}{a SearchSettingsByObject}
#'  \item{sidebarAutoCompleteEnabled}{a character either 'true' or 'false'}
#'  \item{sidebarDropDownListEnabled}{a character either 'true' or 'false'}
#'  \item{sidebarLimitToItemsIOwnCheckboxEnabled}{a character either 'true' or 'false'}
#'  \item{singleSearchResultShortcutEnabled}{a character either 'true' or 'false'}
#'  \item{spellCorrectKnowledgeSearchEnabled}{a character either 'true' or 'false'}
#' }
#'
#' \strong{SearchSettingsByObject}
#'
#' \describe{
#'  \item{searchSettingsByObject}{a ObjectSearchSetting}
#' }
#'
#' \strong{SecuritySettings}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{networkAccess}{a NetworkAccess}
#'  \item{passwordPolicies}{a PasswordPolicies}
#'  \item{sessionSettings}{a SessionSettings}
#' }
#'
#' \strong{ServiceCloudConsoleConfig}
#'
#' \describe{
#'  \item{componentList}{a AppComponentList}
#'  \item{detailPageRefreshMethod}{a character}
#'  \item{footerColor}{a character}
#'  \item{headerColor}{a character}
#'  \item{keyboardShortcuts}{a KeyboardShortcuts}
#'  \item{listPlacement}{a ListPlacement}
#'  \item{listRefreshMethod}{a character}
#'  \item{liveAgentConfig}{a LiveAgentConfig}
#'  \item{primaryTabColor}{a character}
#'  \item{pushNotifications}{a PushNotification}
#'  \item{tabLimitConfig}{a TabLimitConfig}
#'  \item{whitelistedDomains}{a character}
#' }
#'
#' \strong{SessionSettings}
#'
#' \describe{
#'  \item{disableTimeoutWarning}{a character either 'true' or 'false'}
#'  \item{enableCSPOnEmail}{a character either 'true' or 'false'}
#'  \item{enableCSRFOnGet}{a character either 'true' or 'false'}
#'  \item{enableCSRFOnPost}{a character either 'true' or 'false'}
#'  \item{enableCacheAndAutocomplete}{a character either 'true' or 'false'}
#'  \item{enableClickjackNonsetupSFDC}{a character either 'true' or 'false'}
#'  \item{enableClickjackNonsetupUser}{a character either 'true' or 'false'}
#'  \item{enableClickjackNonsetupUserHeaderless}{a character either 'true' or 'false'}
#'  \item{enableClickjackSetup}{a character either 'true' or 'false'}
#'  \item{enableContentSniffingProtection}{a character either 'true' or 'false'}
#'  \item{enablePostForSessions}{a character either 'true' or 'false'}
#'  \item{enableSMSIdentity}{a character either 'true' or 'false'}
#'  \item{enableUpgradeInsecureRequests}{a character either 'true' or 'false'}
#'  \item{enableXssProtection}{a character either 'true' or 'false'}
#'  \item{enforceIpRangesEveryRequest}{a character either 'true' or 'false'}
#'  \item{forceLogoutOnSessionTimeout}{a character either 'true' or 'false'}
#'  \item{forceRelogin}{a character either 'true' or 'false'}
#'  \item{hstsOnForcecomSites}{a character either 'true' or 'false'}
#'  \item{identityConfirmationOnEmailChange}{a character either 'true' or 'false'}
#'  \item{identityConfirmationOnTwoFactorRegistrationEnabled}{a character either 'true' or 'false'}
#'  \item{lockSessionsToDomain}{a character either 'true' or 'false'}
#'  \item{lockSessionsToIp}{a character either 'true' or 'false'}
#'  \item{logoutURL}{a character}
#'  \item{redirectionWarning}{a character either 'true' or 'false'}
#'  \item{referrerPolicy}{a character either 'true' or 'false'}
#'  \item{requireHttpOnly}{a character either 'true' or 'false'}
#'  \item{requireHttps}{a character either 'true' or 'false'}
#'  \item{securityCentralKillSession}{a character either 'true' or 'false'}
#'  \item{sessionTimeout}{a SessionTimeout - which is a character taking one of the following values:
#'    \itemize{
#'      \item{TwentyFourHours}
#'      \item{TwelveHours}
#'      \item{EightHours}
#'      \item{FourHours}
#'      \item{TwoHours}
#'      \item{SixtyMinutes}
#'      \item{ThirtyMinutes}
#'      \item{FifteenMinutes}
#'    }
#'   }
#' }
#'
#' \strong{SFDCMobileSettings}
#'
#' \describe{
#'  \item{enableMobileLite}{a character either 'true' or 'false'}
#'  \item{enableUserToDeviceLinking}{a character either 'true' or 'false'}
#' }
#'
#' \strong{SharedTo}
#'
#' \describe{
#'  \item{allCustomerPortalUsers}{a character}
#'  \item{allInternalUsers}{a character}
#'  \item{allPartnerUsers}{a character}
#'  \item{channelProgramGroup}{a character}
#'  \item{channelProgramGroups}{a character}
#'  \item{group}{a character}
#'  \item{groups}{a character}
#'  \item{managerSubordinates}{a character}
#'  \item{managers}{a character}
#'  \item{portalRole}{a character}
#'  \item{portalRoleAndSubordinates}{a character}
#'  \item{queue}{a character}
#'  \item{role}{a character}
#'  \item{roleAndSubordinates}{a character}
#'  \item{roleAndSubordinatesInternal}{a character}
#'  \item{roles}{a character}
#'  \item{rolesAndSubordinates}{a character}
#'  \item{territories}{a character}
#'  \item{territoriesAndSubordinates}{a character}
#'  \item{territory}{a character}
#'  \item{territoryAndSubordinates}{a character}
#' }
#'
#' \strong{SharingBaseRule}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{accessLevel}{a character}
#'  \item{accountSettings}{a AccountSharingRuleSettings}
#'  \item{description}{a character}
#'  \item{label}{a character}
#'  \item{sharedTo}{a SharedTo}
#' }
#'
#' \strong{SharingCriteriaRule}
#'
#' \describe{
#'  \item{accessLevel}{a character (inherited from SharingBaseRule)}
#'  \item{accountSettings}{a AccountSharingRuleSettings (inherited from SharingBaseRule)}
#'  \item{description}{a character (inherited from SharingBaseRule)}
#'  \item{label}{a character (inherited from SharingBaseRule)}
#'  \item{sharedTo}{a SharedTo (inherited from SharingBaseRule)}
#'  \item{booleanFilter}{a character}
#'  \item{criteriaItems}{a FilterItem}
#' }
#'
#' \strong{SharingOwnerRule}
#'
#' \describe{
#'  \item{accessLevel}{a character (inherited from SharingBaseRule)}
#'  \item{accountSettings}{a AccountSharingRuleSettings (inherited from SharingBaseRule)}
#'  \item{description}{a character (inherited from SharingBaseRule)}
#'  \item{label}{a character (inherited from SharingBaseRule)}
#'  \item{sharedTo}{a SharedTo (inherited from SharingBaseRule)}
#'  \item{sharedFrom}{a SharedTo}
#' }
#'
#' \strong{SharingReason}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{label}{a character}
#' }
#'
#' \strong{SharingReasonTranslation}
#'
#' \describe{
#'  \item{label}{a character}
#'  \item{name}{a character}
#' }
#'
#' \strong{SharingRecalculation}
#'
#' \describe{
#'  \item{className}{a character}
#' }
#'
#' \strong{SharingRules}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{sharingCriteriaRules}{a SharingCriteriaRule}
#'  \item{sharingOwnerRules}{a SharingOwnerRule}
#'  \item{sharingTerritoryRules}{a SharingTerritoryRule}
#' }
#'
#' \strong{SharingSet}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{accessMappings}{a AccessMapping}
#'  \item{description}{a character}
#'  \item{name}{a character}
#'  \item{profiles}{a character}
#' }
#'
#' \strong{SharingTerritoryRule}
#'
#' \describe{
#'  \item{sharedFrom}{a SharedTo (inherited from SharingOwnerRule)}
#' }
#'
#' \strong{SidebarComponent}
#'
#' \describe{
#'  \item{componentType}{a character}
#'  \item{createAction}{a character}
#'  \item{enableLinking}{a character either 'true' or 'false'}
#'  \item{height}{an integer}
#'  \item{label}{a character}
#'  \item{lookup}{a character}
#'  \item{page}{a character}
#'  \item{relatedLists}{a RelatedList}
#'  \item{unit}{a character}
#'  \item{updateAction}{a character}
#'  \item{width}{an integer}
#' }
#'
#' \strong{SiteDotCom}
#'
#' \describe{
#'  \item{content}{a character formed using \code{\link[base64enc]{base64encode}} (inherited from MetadataWithContent)}
#'  \item{label}{a character}
#'  \item{siteType}{a SiteType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Siteforce}
#'      \item{Visualforce}
#'      \item{User}
#'    }
#'   }
#' }
#'
#' \strong{SiteRedirectMapping}
#'
#' \describe{
#'  \item{action}{a SiteRedirect - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Permanent}
#'      \item{Temporary}
#'    }
#'   }
#'  \item{isActive}{a character either 'true' or 'false'}
#'  \item{source}{a character}
#'  \item{target}{a character}
#' }
#'
#' \strong{SiteWebAddress}
#'
#' \describe{
#'  \item{certificate}{a character}
#'  \item{domainName}{a character}
#'  \item{primary}{a character either 'true' or 'false'}
#' }
#'
#' \strong{Skill}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{assignments}{a SkillAssignments}
#'  \item{description}{a character}
#'  \item{label}{a character}
#' }
#'
#' \strong{SkillAssignments}
#'
#' \describe{
#'  \item{profiles}{a SkillProfileAssignments}
#'  \item{users}{a SkillUserAssignments}
#' }
#'
#' \strong{SkillProfileAssignments}
#'
#' \describe{
#'  \item{profile}{a character}
#' }
#'
#' \strong{SkillUserAssignments}
#'
#' \describe{
#'  \item{user}{a character}
#' }
#'
#' \strong{SocialCustomerServiceSettings}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{caseSubjectOption}{a CaseSubjectOption - which is a character taking one of the following values:
#'    \itemize{
#'      \item{SocialPostSource}
#'      \item{SocialPostContent}
#'      \item{BuildCustom}
#'    }
#'   }
#' }
#'
#' \strong{StandardFieldTranslation}
#'
#' \describe{
#'  \item{label}{a character}
#'  \item{name}{a character}
#' }
#'
#' \strong{StandardValue}
#'
#' \describe{
#'  \item{color}{a character (inherited from CustomValue)}
#'  \item{default}{a character either 'true' or 'false' (inherited from CustomValue)}
#'  \item{description}{a character (inherited from CustomValue)}
#'  \item{isActive}{a character either 'true' or 'false' (inherited from CustomValue)}
#'  \item{label}{a character (inherited from CustomValue)}
#'  \item{allowEmail}{a character either 'true' or 'false'}
#'  \item{closed}{a character either 'true' or 'false'}
#'  \item{converted}{a character either 'true' or 'false'}
#'  \item{cssExposed}{a character either 'true' or 'false'}
#'  \item{forecastCategory}{a ForecastCategories - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Omitted}
#'      \item{Pipeline}
#'      \item{BestCase}
#'      \item{Forecast}
#'      \item{Closed}
#'    }
#'   }
#'  \item{groupingString}{a character}
#'  \item{highPriority}{a character either 'true' or 'false'}
#'  \item{probability}{an integer}
#'  \item{reverseRole}{a character}
#'  \item{reviewed}{a character either 'true' or 'false'}
#'  \item{won}{a character either 'true' or 'false'}
#' }
#'
#' \strong{StandardValueSet}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{groupingStringEnum}{a character}
#'  \item{sorted}{a character either 'true' or 'false'}
#'  \item{standardValue}{a StandardValue}
#' }
#'
#' \strong{StandardValueSetTranslation}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{valueTranslation}{a ValueTranslation}
#' }
#'
#' \strong{State}
#'
#' \describe{
#'  \item{active}{a character either 'true' or 'false'}
#'  \item{integrationValue}{a character}
#'  \item{isoCode}{a character}
#'  \item{label}{a character}
#'  \item{standard}{a character either 'true' or 'false'}
#'  \item{visible}{a character either 'true' or 'false'}
#' }
#'
#' \strong{StaticResource}
#'
#' \describe{
#'  \item{content}{a character formed using \code{\link[base64enc]{base64encode}} (inherited from MetadataWithContent)}
#'  \item{cacheControl}{a StaticResourceCacheControl - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Private}
#'      \item{Public}
#'    }
#'   }
#'  \item{contentType}{a character}
#'  \item{description}{a character}
#' }
#'
#' \strong{StrategyNode}
#'
#' \describe{
#'  \item{definition}{a character}
#'  \item{description}{a character}
#'  \item{name}{a character}
#'  \item{parentNode}{a character}
#'  \item{type}{an integer}
#' }
#'
#' \strong{SubtabComponents}
#'
#' \describe{
#'  \item{containers}{a Container}
#' }
#'
#' \strong{SummaryLayout}
#'
#' \describe{
#'  \item{masterLabel}{a character}
#'  \item{sizeX}{an integer}
#'  \item{sizeY}{an integer}
#'  \item{sizeZ}{an integer}
#'  \item{summaryLayoutItems}{a SummaryLayoutItem}
#'  \item{summaryLayoutStyle}{a SummaryLayoutStyle - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Default}
#'      \item{QuoteTemplate}
#'      \item{DefaultQuoteTemplate}
#'      \item{ServiceReportTemplate}
#'      \item{ChildServiceReportTemplateStyle}
#'      \item{DefaultServiceReportTemplate}
#'      \item{CaseInteraction}
#'      \item{QuickActionLayoutLeftRight}
#'      \item{QuickActionLayoutTopDown}
#'      \item{PathAssistant}
#'    }
#'   }
#' }
#'
#' \strong{SummaryLayoutItem}
#'
#' \describe{
#'  \item{customLink}{a character}
#'  \item{field}{a character}
#'  \item{posX}{an integer}
#'  \item{posY}{an integer}
#'  \item{posZ}{an integer}
#' }
#'
#' \strong{SupervisorAgentConfigSkills}
#'
#' \describe{
#'  \item{skill}{a character}
#' }
#'
#' \strong{SynonymDictionary}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{groups}{a SynonymGroup}
#'  \item{isProtected}{a character either 'true' or 'false'}
#'  \item{label}{a character}
#' }
#'
#' \strong{SynonymGroup}
#'
#' \describe{
#'  \item{languages}{a Language - which is a character taking one of the following values:
#'    \itemize{
#'      \item{en_US}
#'      \item{de}
#'      \item{es}
#'      \item{fr}
#'      \item{it}
#'      \item{ja}
#'      \item{sv}
#'      \item{ko}
#'      \item{zh_TW}
#'      \item{zh_CN}
#'      \item{pt_BR}
#'      \item{nl_NL}
#'      \item{da}
#'      \item{th}
#'      \item{fi}
#'      \item{ru}
#'      \item{es_MX}
#'      \item{no}
#'      \item{hu}
#'      \item{pl}
#'      \item{cs}
#'      \item{tr}
#'      \item{in}
#'      \item{ro}
#'      \item{vi}
#'      \item{uk}
#'      \item{iw}
#'      \item{el}
#'      \item{bg}
#'      \item{en_GB}
#'      \item{ar}
#'      \item{sk}
#'      \item{pt_PT}
#'      \item{hr}
#'      \item{sl}
#'      \item{fr_CA}
#'      \item{ka}
#'      \item{sr}
#'      \item{sh}
#'      \item{en_AU}
#'      \item{en_MY}
#'      \item{en_IN}
#'      \item{en_PH}
#'      \item{en_CA}
#'      \item{ro_MD}
#'      \item{bs}
#'      \item{mk}
#'      \item{lv}
#'      \item{lt}
#'      \item{et}
#'      \item{sq}
#'      \item{sh_ME}
#'      \item{mt}
#'      \item{ga}
#'      \item{eu}
#'      \item{cy}
#'      \item{is}
#'      \item{ms}
#'      \item{tl}
#'      \item{lb}
#'      \item{rm}
#'      \item{hy}
#'      \item{hi}
#'      \item{ur}
#'      \item{bn}
#'      \item{de_AT}
#'      \item{de_CH}
#'      \item{ta}
#'      \item{ar_DZ}
#'      \item{ar_BH}
#'      \item{ar_EG}
#'      \item{ar_IQ}
#'      \item{ar_JO}
#'      \item{ar_KW}
#'      \item{ar_LB}
#'      \item{ar_LY}
#'      \item{ar_MA}
#'      \item{ar_OM}
#'      \item{ar_QA}
#'      \item{ar_SA}
#'      \item{ar_SD}
#'      \item{ar_SY}
#'      \item{ar_TN}
#'      \item{ar_AE}
#'      \item{ar_YE}
#'      \item{zh_SG}
#'      \item{zh_HK}
#'      \item{en_HK}
#'      \item{en_IE}
#'      \item{en_SG}
#'      \item{en_ZA}
#'      \item{fr_BE}
#'      \item{fr_LU}
#'      \item{fr_CH}
#'      \item{de_BE}
#'      \item{de_LU}
#'      \item{it_CH}
#'      \item{nl_BE}
#'      \item{es_AR}
#'      \item{es_BO}
#'      \item{es_CL}
#'      \item{es_CO}
#'      \item{es_CR}
#'      \item{es_DO}
#'      \item{es_EC}
#'      \item{es_SV}
#'      \item{es_GT}
#'      \item{es_HN}
#'      \item{es_NI}
#'      \item{es_PA}
#'      \item{es_PY}
#'      \item{es_PE}
#'      \item{es_PR}
#'      \item{es_US}
#'      \item{es_UY}
#'      \item{es_VE}
#'      \item{ca}
#'      \item{eo}
#'      \item{iw_EO}
#'    }
#'   }
#'  \item{terms}{a character}
#' }
#'
#' \strong{TabLimitConfig}
#'
#' \describe{
#'  \item{maxNumberOfPrimaryTabs}{a character}
#'  \item{maxNumberOfSubTabs}{a character}
#' }
#'
#' \strong{Territory}
#'
#' \describe{
#'  \item{caseAccessLevel}{a character (inherited from RoleOrTerritory)}
#'  \item{contactAccessLevel}{a character (inherited from RoleOrTerritory)}
#'  \item{description}{a character (inherited from RoleOrTerritory)}
#'  \item{mayForecastManagerShare}{a character either 'true' or 'false' (inherited from RoleOrTerritory)}
#'  \item{name}{a character (inherited from RoleOrTerritory)}
#'  \item{opportunityAccessLevel}{a character (inherited from RoleOrTerritory)}
#'  \item{accountAccessLevel}{a character}
#'  \item{parentTerritory}{a character}
#' }
#'
#' \strong{Territory2}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{accountAccessLevel}{a character}
#'  \item{caseAccessLevel}{a character}
#'  \item{contactAccessLevel}{a character}
#'  \item{customFields}{a FieldValue}
#'  \item{description}{a character}
#'  \item{name}{a character}
#'  \item{opportunityAccessLevel}{a character}
#'  \item{parentTerritory}{a character}
#'  \item{ruleAssociations}{a Territory2RuleAssociation}
#'  \item{territory2Type}{a character}
#' }
#'
#' \strong{Territory2Model}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{customFields}{a FieldValue}
#'  \item{description}{a character}
#'  \item{name}{a character}
#' }
#'
#' \strong{Territory2Rule}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{active}{a character either 'true' or 'false'}
#'  \item{booleanFilter}{a character}
#'  \item{name}{a character}
#'  \item{objectType}{a character}
#'  \item{ruleItems}{a Territory2RuleItem}
#' }
#'
#' \strong{Territory2RuleAssociation}
#'
#' \describe{
#'  \item{inherited}{a character either 'true' or 'false'}
#'  \item{ruleName}{a character}
#' }
#'
#' \strong{Territory2RuleItem}
#'
#' \describe{
#'  \item{field}{a character}
#'  \item{operation}{a FilterOperation - which is a character taking one of the following values:
#'    \itemize{
#'      \item{equals}
#'      \item{notEqual}
#'      \item{lessThan}
#'      \item{greaterThan}
#'      \item{lessOrEqual}
#'      \item{greaterOrEqual}
#'      \item{contains}
#'      \item{notContain}
#'      \item{startsWith}
#'      \item{includes}
#'      \item{excludes}
#'      \item{within}
#'    }
#'   }
#'  \item{value}{a character}
#' }
#'
#' \strong{Territory2Settings}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{defaultAccountAccessLevel}{a character}
#'  \item{defaultCaseAccessLevel}{a character}
#'  \item{defaultContactAccessLevel}{a character}
#'  \item{defaultOpportunityAccessLevel}{a character}
#'  \item{opportunityFilterSettings}{a Territory2SettingsOpportunityFilter}
#' }
#'
#' \strong{Territory2SettingsOpportunityFilter}
#'
#' \describe{
#'  \item{apexClassName}{a character}
#'  \item{enableFilter}{a character either 'true' or 'false'}
#'  \item{runOnCreate}{a character either 'true' or 'false'}
#' }
#'
#' \strong{Territory2Type}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{description}{a character}
#'  \item{name}{a character}
#'  \item{priority}{an integer}
#' }
#'
#' \strong{TopicsForObjects}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{enableTopics}{a character either 'true' or 'false'}
#'  \item{entityApiName}{a character}
#' }
#'
#' \strong{TouchMobileSettings}
#'
#' \describe{
#'  \item{enableTouchAppIPad}{a character either 'true' or 'false'}
#'  \item{enableTouchAppIPhone}{a character either 'true' or 'false'}
#'  \item{enableTouchBrowserIPad}{a character either 'true' or 'false'}
#'  \item{enableTouchIosPhone}{a character either 'true' or 'false'}
#'  \item{enableVisualforceInTouch}{a character either 'true' or 'false'}
#' }
#'
#' \strong{TransactionSecurityAction}
#'
#' \describe{
#'  \item{block}{a character either 'true' or 'false'}
#'  \item{endSession}{a character either 'true' or 'false'}
#'  \item{freezeUser}{a character either 'true' or 'false'}
#'  \item{notifications}{a TransactionSecurityNotification}
#'  \item{twoFactorAuthentication}{a character either 'true' or 'false'}
#' }
#'
#' \strong{TransactionSecurityNotification}
#'
#' \describe{
#'  \item{inApp}{a character either 'true' or 'false'}
#'  \item{sendEmail}{a character either 'true' or 'false'}
#'  \item{user}{a character}
#' }
#'
#' \strong{TransactionSecurityPolicy}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{action}{a TransactionSecurityAction}
#'  \item{active}{a character either 'true' or 'false'}
#'  \item{apexClass}{a character}
#'  \item{description}{a character}
#'  \item{developerName}{a character}
#'  \item{eventName}{a TransactionSecurityEventName - which is a character taking one of the following values:
#'    \itemize{
#'      \item{ReportEvent}
#'      \item{ApiEvent}
#'      \item{AdminSetupEvent}
#'      \item{LoginEvent}
#'    }
#'   }
#'  \item{eventType}{a MonitoredEvents - which is a character taking one of the following values:
#'    \itemize{
#'      \item{AuditTrail}
#'      \item{Login}
#'      \item{Entity}
#'      \item{DataExport}
#'      \item{AccessResource}
#'    }
#'   }
#'  \item{executionUser}{a character}
#'  \item{flow}{a character}
#'  \item{masterLabel}{a character}
#'  \item{resourceName}{a character}
#'  \item{type}{a TxnSecurityPolicyType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{CustomApexPolicy}
#'      \item{CustomConditionBuilderPolicy}
#'    }
#'   }
#' }
#'
#' \strong{Translations}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{customApplications}{a CustomApplicationTranslation}
#'  \item{customDataTypeTranslations}{a CustomDataTypeTranslation}
#'  \item{customLabels}{a CustomLabelTranslation}
#'  \item{customPageWebLinks}{a CustomPageWebLinkTranslation}
#'  \item{customTabs}{a CustomTabTranslation}
#'  \item{flowDefinitions}{a FlowDefinitionTranslation}
#'  \item{quickActions}{a GlobalQuickActionTranslation}
#'  \item{reportTypes}{a ReportTypeTranslation}
#'  \item{scontrols}{a ScontrolTranslation}
#' }
#'
#' \strong{UiFormulaCriterion}
#'
#' \describe{
#'  \item{leftValue}{a character}
#'  \item{operator}{a character}
#'  \item{rightValue}{a character}
#' }
#'
#' \strong{UiFormulaRule}
#'
#' \describe{
#'  \item{booleanFilter}{a character}
#'  \item{criteria}{a UiFormulaCriterion}
#' }
#'
#' \strong{UiPlugin}
#'
#' \describe{
#'  \item{content}{a character formed using \code{\link[base64enc]{base64encode}} (inherited from MetadataWithContent)}
#'  \item{description}{a character}
#'  \item{extensionPointIdentifier}{a character}
#'  \item{isEnabled}{a character either 'true' or 'false'}
#'  \item{language}{a character}
#'  \item{masterLabel}{a character}
#' }
#'
#' \strong{UserCriteria}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{creationAgeInSeconds}{an integer}
#'  \item{description}{a character}
#'  \item{lastChatterActivityAgeInSeconds}{an integer}
#'  \item{masterLabel}{a character}
#'  \item{profiles}{a character}
#'  \item{userTypes}{a NetworkUserType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Internal}
#'      \item{Customer}
#'      \item{Partner}
#'    }
#'   }
#' }
#'
#' \strong{Users}
#'
#' \describe{
#'  \item{user}{a character}
#' }
#'
#' \strong{ValidationRule}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{active}{a character either 'true' or 'false'}
#'  \item{description}{a character}
#'  \item{errorConditionFormula}{a character}
#'  \item{errorDisplayField}{a character}
#'  \item{errorMessage}{a character}
#' }
#'
#' \strong{ValidationRuleTranslation}
#'
#' \describe{
#'  \item{errorMessage}{a character}
#'  \item{name}{a character}
#' }
#'
#' \strong{ValueSet}
#'
#' \describe{
#'  \item{controllingField}{a character}
#'  \item{restricted}{a character either 'true' or 'false'}
#'  \item{valueSetDefinition}{a ValueSetValuesDefinition}
#'  \item{valueSetName}{a character}
#'  \item{valueSettings}{a ValueSettings}
#' }
#'
#' \strong{ValueSettings}
#'
#' \describe{
#'  \item{controllingFieldValue}{a character}
#'  \item{valueName}{a character}
#' }
#'
#' \strong{ValueSetValuesDefinition}
#'
#' \describe{
#'  \item{sorted}{a character either 'true' or 'false'}
#'  \item{value}{a CustomValue}
#' }
#'
#' \strong{ValueTranslation}
#'
#' \describe{
#'  \item{masterLabel}{a character}
#'  \item{translation}{a character}
#' }
#'
#' \strong{ValueTypeField}
#'
#' \describe{
#'  \item{fields}{a ValueTypeField}
#'  \item{foreignKeyDomain}{a character}
#'  \item{isForeignKey}{a character either 'true' or 'false'}
#'  \item{isNameField}{a character either 'true' or 'false'}
#'  \item{minOccurs}{an integer}
#'  \item{name}{a character}
#'  \item{picklistValues}{a PicklistEntry}
#'  \item{soapType}{a character}
#'  \item{valueRequired}{a character either 'true' or 'false'}
#' }
#'
#' \strong{VisualizationPlugin}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{description}{a character}
#'  \item{developerName}{a character}
#'  \item{icon}{a character}
#'  \item{masterLabel}{a character}
#'  \item{visualizationResources}{a VisualizationResource}
#'  \item{visualizationTypes}{a VisualizationType}
#' }
#'
#' \strong{VisualizationResource}
#'
#' \describe{
#'  \item{description}{a character}
#'  \item{file}{a character}
#'  \item{rank}{an integer}
#'  \item{type}{a VisualizationResourceType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{js}
#'      \item{css}
#'    }
#'   }
#' }
#'
#' \strong{VisualizationType}
#'
#' \describe{
#'  \item{description}{a character}
#'  \item{developerName}{a character}
#'  \item{icon}{a character}
#'  \item{masterLabel}{a character}
#'  \item{scriptBootstrapMethod}{a character}
#' }
#'
#' \strong{WaveApplication}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{assetIcon}{a character}
#'  \item{description}{a character}
#'  \item{folder}{a character}
#'  \item{masterLabel}{a character}
#'  \item{shares}{a FolderShare}
#'  \item{templateOrigin}{a character}
#'  \item{templateVersion}{a character}
#' }
#'
#' \strong{WaveDashboard}
#'
#' \describe{
#'  \item{content}{a character formed using \code{\link[base64enc]{base64encode}} (inherited from MetadataWithContent)}
#'  \item{application}{a character}
#'  \item{description}{a character}
#'  \item{masterLabel}{a character}
#'  \item{templateAssetSourceName}{a character}
#' }
#'
#' \strong{WaveDataflow}
#'
#' \describe{
#'  \item{content}{a character formed using \code{\link[base64enc]{base64encode}} (inherited from MetadataWithContent)}
#'  \item{dataflowType}{a character}
#'  \item{description}{a character}
#'  \item{masterLabel}{a character}
#' }
#'
#' \strong{WaveDataset}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{application}{a character}
#'  \item{description}{a character}
#'  \item{masterLabel}{a character}
#'  \item{templateAssetSourceName}{a character}
#' }
#'
#' \strong{WaveLens}
#'
#' \describe{
#'  \item{content}{a character formed using \code{\link[base64enc]{base64encode}} (inherited from MetadataWithContent)}
#'  \item{application}{a character}
#'  \item{datasets}{a character}
#'  \item{description}{a character}
#'  \item{masterLabel}{a character}
#'  \item{templateAssetSourceName}{a character}
#'  \item{visualizationType}{a character}
#' }
#'
#' \strong{WaveRecipe}
#'
#' \describe{
#'  \item{content}{a character formed using \code{\link[base64enc]{base64encode}} (inherited from MetadataWithContent)}
#'  \item{dataflow}{a character}
#'  \item{masterLabel}{a character}
#'  \item{securityPredicate}{a character}
#'  \item{targetDatasetAlias}{a character}
#' }
#'
#' \strong{WaveTemplateBundle}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{assetIcon}{a character}
#'  \item{assetVersion}{a numeric}
#'  \item{description}{a character}
#'  \item{label}{a character}
#'  \item{templateBadgeIcon}{a character}
#'  \item{templateDetailIcon}{a character}
#'  \item{templateType}{a character}
#' }
#'
#' \strong{WaveXmd}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{application}{a character}
#'  \item{dataset}{a character}
#'  \item{datasetConnector}{a character}
#'  \item{datasetFullyQualifiedName}{a character}
#'  \item{dates}{a WaveXmdDate}
#'  \item{dimensions}{a WaveXmdDimension}
#'  \item{measures}{a WaveXmdMeasure}
#'  \item{organizations}{a WaveXmdOrganization}
#'  \item{origin}{a character}
#'  \item{type}{a character}
#'  \item{waveVisualization}{a character}
#' }
#'
#' \strong{WaveXmdDate}
#'
#' \describe{
#'  \item{alias}{a character}
#'  \item{compact}{a character either 'true' or 'false'}
#'  \item{dateFieldDay}{a character}
#'  \item{dateFieldEpochDay}{a character}
#'  \item{dateFieldEpochSecond}{a character}
#'  \item{dateFieldFiscalMonth}{a character}
#'  \item{dateFieldFiscalQuarter}{a character}
#'  \item{dateFieldFiscalWeek}{a character}
#'  \item{dateFieldFiscalYear}{a character}
#'  \item{dateFieldFullYear}{a character}
#'  \item{dateFieldHour}{a character}
#'  \item{dateFieldMinute}{a character}
#'  \item{dateFieldMonth}{a character}
#'  \item{dateFieldQuarter}{a character}
#'  \item{dateFieldSecond}{a character}
#'  \item{dateFieldWeek}{a character}
#'  \item{dateFieldYear}{a character}
#'  \item{description}{a character}
#'  \item{firstDayOfWeek}{an integer}
#'  \item{fiscalMonthOffset}{an integer}
#'  \item{isYearEndFiscalYear}{a character either 'true' or 'false'}
#'  \item{label}{a character}
#'  \item{showInExplorer}{a character either 'true' or 'false'}
#'  \item{sortIndex}{an integer}
#' }
#'
#' \strong{WaveXmdDimension}
#'
#' \describe{
#'  \item{customActions}{a WaveXmdDimensionCustomAction}
#'  \item{customActionsEnabled}{a character either 'true' or 'false'}
#'  \item{dateFormat}{a character}
#'  \item{description}{a character}
#'  \item{field}{a character}
#'  \item{fullyQualifiedName}{a character}
#'  \item{imageTemplate}{a character}
#'  \item{isDerived}{a character either 'true' or 'false'}
#'  \item{isMultiValue}{a character either 'true' or 'false'}
#'  \item{label}{a character}
#'  \item{linkTemplate}{a character}
#'  \item{linkTemplateEnabled}{a character either 'true' or 'false'}
#'  \item{linkTooltip}{a character}
#'  \item{members}{a WaveXmdDimensionMember}
#'  \item{origin}{a character}
#'  \item{recordDisplayFields}{a WaveXmdRecordDisplayLookup}
#'  \item{recordIdField}{a character}
#'  \item{recordOrganizationIdField}{a character}
#'  \item{salesforceActions}{a WaveXmdDimensionSalesforceAction}
#'  \item{salesforceActionsEnabled}{a character either 'true' or 'false'}
#'  \item{showDetailsDefaultFieldIndex}{an integer}
#'  \item{showInExplorer}{a character either 'true' or 'false'}
#'  \item{sortIndex}{an integer}
#' }
#'
#' \strong{WaveXmdDimensionCustomAction}
#'
#' \describe{
#'  \item{customActionName}{a character}
#'  \item{enabled}{a character either 'true' or 'false'}
#'  \item{icon}{a character}
#'  \item{method}{a character}
#'  \item{sortIndex}{an integer}
#'  \item{target}{a character}
#'  \item{tooltip}{a character}
#'  \item{url}{a character}
#' }
#'
#' \strong{WaveXmdDimensionMember}
#'
#' \describe{
#'  \item{color}{a character}
#'  \item{label}{a character}
#'  \item{member}{a character}
#'  \item{sortIndex}{an integer}
#' }
#'
#' \strong{WaveXmdDimensionSalesforceAction}
#'
#' \describe{
#'  \item{enabled}{a character either 'true' or 'false'}
#'  \item{salesforceActionName}{a character}
#'  \item{sortIndex}{an integer}
#' }
#'
#' \strong{WaveXmdMeasure}
#'
#' \describe{
#'  \item{dateFormat}{a character}
#'  \item{description}{a character}
#'  \item{field}{a character}
#'  \item{formatCustomFormat}{a character}
#'  \item{formatDecimalDigits}{an integer}
#'  \item{formatIsNegativeParens}{a character either 'true' or 'false'}
#'  \item{formatPrefix}{a character}
#'  \item{formatSuffix}{a character}
#'  \item{formatUnit}{a character}
#'  \item{formatUnitMultiplier}{a numeric}
#'  \item{fullyQualifiedName}{a character}
#'  \item{isDerived}{a character either 'true' or 'false'}
#'  \item{label}{a character}
#'  \item{origin}{a character}
#'  \item{showDetailsDefaultFieldIndex}{an integer}
#'  \item{showInExplorer}{a character either 'true' or 'false'}
#'  \item{sortIndex}{an integer}
#' }
#'
#' \strong{WaveXmdOrganization}
#'
#' \describe{
#'  \item{instanceUrl}{a character}
#'  \item{label}{a character}
#'  \item{organizationIdentifier}{a character}
#'  \item{sortIndex}{an integer}
#' }
#'
#' \strong{WaveXmdRecordDisplayLookup}
#'
#' \describe{
#'  \item{recordDisplayField}{a character}
#' }
#'
#' \strong{WebLink}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{availability}{a WebLinkAvailability - which is a character taking one of the following values:
#'    \itemize{
#'      \item{online}
#'      \item{offline}
#'    }
#'   }
#'  \item{description}{a character}
#'  \item{displayType}{a WebLinkDisplayType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{link}
#'      \item{button}
#'      \item{massActionButton}
#'    }
#'   }
#'  \item{encodingKey}{a Encoding - which is a character taking one of the following values:
#'    \itemize{
#'      \item{UTF-8}
#'      \item{ISO-8859-1}
#'      \item{Shift_JIS}
#'      \item{ISO-2022-JP}
#'      \item{EUC-JP}
#'      \item{ks_c_5601-1987}
#'      \item{Big5}
#'      \item{GB2312}
#'      \item{Big5-HKSCS}
#'      \item{x-SJIS_0213}
#'    }
#'   }
#'  \item{hasMenubar}{a character either 'true' or 'false'}
#'  \item{hasScrollbars}{a character either 'true' or 'false'}
#'  \item{hasToolbar}{a character either 'true' or 'false'}
#'  \item{height}{an integer}
#'  \item{isResizable}{a character either 'true' or 'false'}
#'  \item{linkType}{a WebLinkType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{url}
#'      \item{sControl}
#'      \item{javascript}
#'      \item{page}
#'      \item{flow}
#'    }
#'   }
#'  \item{masterLabel}{a character}
#'  \item{openType}{a WebLinkWindowType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{newWindow}
#'      \item{sidebar}
#'      \item{noSidebar}
#'      \item{replace}
#'      \item{onClickJavaScript}
#'    }
#'   }
#'  \item{page}{a character}
#'  \item{position}{a WebLinkPosition - which is a character taking one of the following values:
#'    \itemize{
#'      \item{fullScreen}
#'      \item{none}
#'      \item{topLeft}
#'    }
#'   }
#'  \item{protected}{a character either 'true' or 'false'}
#'  \item{requireRowSelection}{a character either 'true' or 'false'}
#'  \item{scontrol}{a character}
#'  \item{showsLocation}{a character either 'true' or 'false'}
#'  \item{showsStatus}{a character either 'true' or 'false'}
#'  \item{url}{a character}
#'  \item{width}{an integer}
#' }
#'
#' \strong{WebLinkTranslation}
#'
#' \describe{
#'  \item{label}{a character}
#'  \item{name}{a character}
#' }
#'
#' \strong{WebToCaseSettings}
#'
#' \describe{
#'  \item{caseOrigin}{a character}
#'  \item{defaultResponseTemplate}{a character}
#'  \item{enableWebToCase}{a character either 'true' or 'false'}
#' }
#'
#' \strong{WeightedSourceCategory}
#'
#' \describe{
#'  \item{sourceCategoryApiName}{a character}
#'  \item{weight}{a numeric}
#' }
#'
#' \strong{Workflow}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{alerts}{a WorkflowAlert}
#'  \item{fieldUpdates}{a WorkflowFieldUpdate}
#'  \item{flowActions}{a WorkflowFlowAction}
#'  \item{knowledgePublishes}{a WorkflowKnowledgePublish}
#'  \item{outboundMessages}{a WorkflowOutboundMessage}
#'  \item{rules}{a WorkflowRule}
#'  \item{send}{a WorkflowSend}
#'  \item{tasks}{a WorkflowTask}
#' }
#'
#' \strong{WorkflowAction}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#' }
#'
#' \strong{WorkflowActionReference}
#'
#' \describe{
#'  \item{name}{a character}
#'  \item{type}{a WorkflowActionType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{FieldUpdate}
#'      \item{KnowledgePublish}
#'      \item{Task}
#'      \item{Alert}
#'      \item{Send}
#'      \item{OutboundMessage}
#'      \item{FlowAction}
#'    }
#'   }
#' }
#'
#' \strong{WorkflowAlert}
#'
#' \describe{
#'  \item{extends WorkflowAction}{see documentation for WorkflowAction}
#'  \item{ccEmails}{a character}
#'  \item{description}{a character}
#'  \item{protected}{a character either 'true' or 'false'}
#'  \item{recipients}{a WorkflowEmailRecipient}
#'  \item{senderAddress}{a character}
#'  \item{senderType}{a ActionEmailSenderType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{CurrentUser}
#'      \item{OrgWideEmailAddress}
#'      \item{DefaultWorkflowUser}
#'    }
#'   }
#'  \item{template}{a character}
#' }
#'
#' \strong{WorkflowEmailRecipient}
#'
#' \describe{
#'  \item{field}{a character}
#'  \item{recipient}{a character}
#'  \item{type}{a ActionEmailRecipientTypes - which is a character taking one of the following values:
#'    \itemize{
#'      \item{group}
#'      \item{role}
#'      \item{user}
#'      \item{opportunityTeam}
#'      \item{accountTeam}
#'      \item{roleSubordinates}
#'      \item{owner}
#'      \item{creator}
#'      \item{partnerUser}
#'      \item{accountOwner}
#'      \item{customerPortalUser}
#'      \item{portalRole}
#'      \item{portalRoleSubordinates}
#'      \item{contactLookup}
#'      \item{userLookup}
#'      \item{roleSubordinatesInternal}
#'      \item{email}
#'      \item{caseTeam}
#'      \item{campaignMemberDerivedOwner}
#'    }
#'   }
#' }
#'
#' \strong{WorkflowFieldUpdate}
#'
#' \describe{
#'  \item{extends WorkflowAction}{see documentation for WorkflowAction}
#'  \item{description}{a character}
#'  \item{field}{a character}
#'  \item{formula}{a character}
#'  \item{literalValue}{a character}
#'  \item{lookupValue}{a character}
#'  \item{lookupValueType}{a LookupValueType - which is a character taking one of the following values:
#'    \itemize{
#'      \item{User}
#'      \item{Queue}
#'      \item{RecordType}
#'    }
#'   }
#'  \item{name}{a character}
#'  \item{notifyAssignee}{a character either 'true' or 'false'}
#'  \item{operation}{a FieldUpdateOperation - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Formula}
#'      \item{Literal}
#'      \item{Null}
#'      \item{NextValue}
#'      \item{PreviousValue}
#'      \item{LookupValue}
#'    }
#'   }
#'  \item{protected}{a character either 'true' or 'false'}
#'  \item{reevaluateOnChange}{a character either 'true' or 'false'}
#'  \item{targetObject}{a character}
#' }
#'
#' \strong{WorkflowFlowAction}
#'
#' \describe{
#'  \item{extends WorkflowAction}{see documentation for WorkflowAction}
#'  \item{description}{a character}
#'  \item{flow}{a character}
#'  \item{flowInputs}{a WorkflowFlowActionParameter}
#'  \item{label}{a character}
#'  \item{language}{a character}
#'  \item{protected}{a character either 'true' or 'false'}
#' }
#'
#' \strong{WorkflowFlowActionParameter}
#'
#' \describe{
#'  \item{name}{a character}
#'  \item{value}{a character}
#' }
#'
#' \strong{WorkflowKnowledgePublish}
#'
#' \describe{
#'  \item{extends WorkflowAction}{see documentation for WorkflowAction}
#'  \item{action}{a KnowledgeWorkflowAction - which is a character taking one of the following values:
#'    \itemize{
#'      \item{PublishAsNew}
#'      \item{Publish}
#'    }
#'   }
#'  \item{description}{a character}
#'  \item{label}{a character}
#'  \item{language}{a character}
#'  \item{protected}{a character either 'true' or 'false'}
#' }
#'
#' \strong{WorkflowRule}
#'
#' \describe{
#'  \item{fullName}{a character (inherited from Metadata)}
#'  \item{actions}{a WorkflowActionReference}
#'  \item{active}{a character either 'true' or 'false'}
#'  \item{booleanFilter}{a character}
#'  \item{criteriaItems}{a FilterItem}
#'  \item{description}{a character}
#'  \item{formula}{a character}
#'  \item{triggerType}{a WorkflowTriggerTypes - which is a character taking one of the following values:
#'    \itemize{
#'      \item{onCreateOnly}
#'      \item{onCreateOrTriggeringUpdate}
#'      \item{onAllChanges}
#'      \item{OnRecursiveUpdate}
#'    }
#'   }
#'  \item{workflowTimeTriggers}{a WorkflowTimeTrigger}
#' }
#'
#' \strong{WorkflowSend}
#'
#' \describe{
#'  \item{extends WorkflowAction}{see documentation for WorkflowAction}
#'  \item{action}{a SendAction - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Send}
#'    }
#'   }
#'  \item{description}{a character}
#'  \item{label}{a character}
#'  \item{language}{a character}
#'  \item{protected}{a character either 'true' or 'false'}
#' }
#'
#' \strong{WorkflowTask}
#'
#' \describe{
#'  \item{extends WorkflowAction}{see documentation for WorkflowAction}
#'  \item{assignedTo}{a character}
#'  \item{assignedToType}{a ActionTaskAssignedToTypes - which is a character taking one of the following values:
#'    \itemize{
#'      \item{user}
#'      \item{role}
#'      \item{opportunityTeam}
#'      \item{accountTeam}
#'      \item{owner}
#'      \item{accountOwner}
#'      \item{creator}
#'      \item{accountCreator}
#'      \item{partnerUser}
#'      \item{portalRole}
#'    }
#'   }
#'  \item{description}{a character}
#'  \item{dueDateOffset}{an integer}
#'  \item{notifyAssignee}{a character either 'true' or 'false'}
#'  \item{offsetFromField}{a character}
#'  \item{priority}{a character}
#'  \item{protected}{a character either 'true' or 'false'}
#'  \item{status}{a character}
#'  \item{subject}{a character}
#' }
#'
#' \strong{WorkflowTaskTranslation}
#'
#' \describe{
#'  \item{description}{a character}
#'  \item{name}{a character}
#'  \item{subject}{a character}
#' }
#'
#' \strong{WorkflowTimeTrigger}
#'
#' \describe{
#'  \item{actions}{a WorkflowActionReference}
#'  \item{offsetFromField}{a character}
#'  \item{timeLength}{a character}
#'  \item{workflowTimeTriggerUnit}{a WorkflowTimeUnits - which is a character taking one of the following values:
#'    \itemize{
#'      \item{Hours}
#'      \item{Days}
#'    }
#'   }
#' }
#'
#' \strong{WorkspaceMapping}
#'
#' \describe{
#'  \item{fieldName}{a character}
#'  \item{tab}{a character}
#' }
#'
#' @param obj_type a string from one of the object types described above
#' @param obj_data a \code{list} of \code{lists} or a \code{data.frame} with the required inputs to create the
#' the obj_type specified.
#' @return a \code{list} that can be used as input to one of the CRUD Metadata API
#' operations: \link{sf_create_metadata}, \link{sf_update_metadata}, \link{sf_update_metadata}
#' @export
metadata_type_validator <- function(obj_type, obj_data){

 stopifnot(length(obj_data) > 0)
 stopifnot(is.list(obj_data) | is.data.frame(obj_data))

 if(is.data.frame(obj_data))
   obj_data <- split(obj_data, seq(nrow(obj_data)))
 if(typeof(obj_data[[1]]) != "list")
   obj_data <- list(obj_data)

 acceptable_inputs <- valid_metadata_list()[[obj_type]]

 if(length(acceptable_inputs) < 1)
    stop(paste0("No input validation could be found for the obj_type specified: ", obj_type))

 new_obj_data <- list()
 counter <- 1
 for (e in 1:length(obj_data)){
    # pull out only the acceptable inputs, just ignore the rest
    obj_data[[e]] <- obj_data[[e]][names(obj_data[[e]]) %in% acceptable_inputs]
    # reorder according to WSDL since order matters
    matched_order <- order(match(names(obj_data[[e]]), acceptable_inputs))

    if(all(is.na(matched_order))){
      message(sprintf(paste0("Some of the records were dropped because their ",
                             "inputs did not match the acceptable inputs for ",
                             "the specified data type: %s", obj_type)))
    }

    obj_data[[e]] <- obj_data[[e]][matched_order[!is.na(matched_order)]]

    # add to the final formatted object if it is a record with some valid input elements
    if(length(obj_data[[e]]) > 0){
      new_obj_data[[counter]] <- obj_data[[e]]
      counter <- counter + 1
    }
 }

 return(new_obj_data)
}

#' List of Valid Data Types
#'
#' A list of data types that are valid for the Metadata API service.
#'
#' @return \code{list}; contains name and valid inputs for data types
#' @export
valid_metadata_list <- function(){

  reference_list <- list(
    "AccessMapping"=c('accessLevel','object','objectField','userField'),
    "AccountSettings"=c('fullName','enableAccountOwnerReport','enableAccountTeams','showViewHierarchyLink'),
    "AccountSharingRuleSettings"=c('caseAccessLevel','contactAccessLevel','opportunityAccessLevel'),
    "ActionLinkGroupTemplate"=c('fullName','actionLinkTemplates','category','executionsAllowed','hoursUntilExpiration','isPublished','name'),
    "ActionLinkTemplate"=c('actionUrl','headers','isConfirmationRequired','isGroupDefault','label','labelKey','linkType','method','position','requestBody','userAlias','userVisibility'),
    "ActionOverride"=c('actionName','comment','content','formFactor','skipRecordTypeSelect','type'),
    "ActivitiesSettings"=c('fullName','allowUsersToRelateMultipleContactsToTasksAndEvents','autoRelateEventAttendees','enableActivityReminders','enableClickCreateEvents','enableDragAndDropScheduling','enableEmailTracking','enableGroupTasks','enableListViewScheduling','enableLogNote','enableMultidayEvents','enableRecurringEvents','enableRecurringTasks','enableSidebarCalendarShortcut','enableSimpleTaskCreateUI','enableUNSTaskDelegatedToNotifications','meetingRequestsLogo','showCustomLogoMeetingRequests','showEventDetailsMultiUserCalendar','showHomePageHoverLinksForEvents','showMyTasksHoverLinks'),
    "AddressSettings"=c('fullName','countriesAndStates'),
    "AdjustmentsSettings"=c('enableAdjustments','enableOwnerAdjustments'),
    "AgentConfigAssignments"=c('profiles','users'),
    "AgentConfigButtons"=c('button'),
    "AgentConfigProfileAssignments"=c('profile'),
    "AgentConfigSkills"=c('skill'),
    "AgentConfigUserAssignments"=c('user'),
    "AnalyticsCloudComponentLayoutItem"=c('assetType','devName','error','filter','height','hideOnError','showHeader','showSharing','showTitle','width'),
    "AnalyticSnapshot"=c('fullName','description','groupColumn','mappings','name','runningUser','sourceReport','targetObject'),
    "AnalyticSnapshotMapping"=c('aggregateType','sourceField','sourceType','targetField'),
    "ApexClass"=c('content','apiVersion','packageVersions','status'),
    "ApexComponent"=c('content','apiVersion','description','label','packageVersions'),
    "ApexPage"=c('content','apiVersion','availableInTouch','confirmationTokenRequired','description','label','packageVersions'),
    "ApexTestSuite"=c('fullName','testClassName'),
    "ApexTrigger"=c('content','apiVersion','packageVersions','status'),
    "AppActionOverride"=c('actionName','comment','content','formFactor','skipRecordTypeSelect','type','pageOrSobjectType'),
    "AppBrand"=c('footerColor','headerColor','logo','logoVersion','shouldOverrideOrgTheme'),
    "AppComponentList"=c('alignment','components'),
    "AppMenu"=c('fullName','appMenuItems'),
    "AppMenuItem"=c('name','type'),
    "AppPreferences"=c('enableCustomizeMyTabs','enableKeyboardShortcuts','enableListViewHover','enableListViewReskin','enableMultiMonitorComponents','enablePinTabs','enableTabHover','enableTabLimits','saveUserSessions'),
    "AppProfileActionOverride"=c('actionName','content','formFactor','pageOrSobjectType','recordType','type','profile'),
    "ApprovalAction"=c('action'),
    "ApprovalEntryCriteria"=c('booleanFilter','criteriaItems','formula'),
    "ApprovalPageField"=c('field'),
    "ApprovalProcess"=c('fullName','active','allowRecall','allowedSubmitters','approvalPageFields','approvalStep','description','emailTemplate','enableMobileDeviceAccess','entryCriteria','finalApprovalActions','finalApprovalRecordLock','finalRejectionActions','finalRejectionRecordLock','initialSubmissionActions','label','nextAutomatedApprover','postTemplate','recallActions','recordEditability','showApprovalHistory'),
    "ApprovalStep"=c('allowDelegate','approvalActions','assignedApprover','description','entryCriteria','ifCriteriaNotMet','label','name','rejectBehavior','rejectionActions'),
    "ApprovalStepApprover"=c('approver','whenMultipleApprovers'),
    "ApprovalStepRejectBehavior"=c('type'),
    "ApprovalSubmitter"=c('submitter','type'),
    "Approver"=c('name','type'),
    "AppWorkspaceConfig"=c('mappings'),
    "ArticleTypeChannelDisplay"=c('articleTypeTemplates'),
    "ArticleTypeTemplate"=c('channel','page','template'),
    "AssignmentRule"=c('fullName','active','ruleEntry'),
    "AssignmentRules"=c('fullName','assignmentRule'),
    "AssistantRecommendationType"=c('fullName','description','masterLabel','platformActionlist','sobjectType','title'),
    "Attachment"=c('content','name'),
    "AuraDefinitionBundle"=c('fullName','SVGContent','apiVersion','controllerContent','description','designContent','documentationContent','helperContent','markup','modelContent','packageVersions','rendererContent','styleContent','testsuiteContent','type'),
    "AuthProvider"=c('fullName','authorizeUrl','consumerKey','consumerSecret','customMetadataTypeRecord','defaultScopes','errorUrl','executionUser','friendlyName','iconUrl','idTokenIssuer','includeOrgIdInIdentifier','logoutUrl','plugin','portal','providerType','registrationHandler','sendAccessTokenInHeader','sendClientCredentialsInHeader','tokenUrl','userInfoUrl'),
    "AutoResponseRule"=c('fullName','active','ruleEntry'),
    "AutoResponseRules"=c('fullName','autoResponseRule'),
    "BrandingSet"=c('fullName','brandingSetProperty','description','masterLabel','type'),
    "BrandingSetProperty"=c('propertyName','propertyValue'),
    "BusinessHoursEntry"=c('fullName','active','default','fridayEndTime','fridayStartTime','mondayEndTime','mondayStartTime','name','saturdayEndTime','saturdayStartTime','sundayEndTime','sundayStartTime','thursdayEndTime','thursdayStartTime','timeZoneId','tuesdayEndTime','tuesdayStartTime','wednesdayEndTime','wednesdayStartTime'),
    "BusinessHoursSettings"=c('fullName','businessHours','holidays'),
    "BusinessProcess"=c('fullName','description','isActive','values'),
    "CallCenter"=c('fullName','adapterUrl','customSettings','displayName','displayNameLabel','internalNameLabel','sections','version'),
    "CallCenterItem"=c('label','name','value'),
    "CallCenterSection"=c('items','label','name'),
    "CampaignInfluenceModel"=c('fullName','isActive','isDefaultModel','isModelLocked','modelDescription','name','recordPreference'),
    "CaseSettings"=c('fullName','caseAssignNotificationTemplate','caseCloseNotificationTemplate','caseCommentNotificationTemplate','caseCreateNotificationTemplate','caseFeedItemSettings','closeCaseThroughStatusChange','defaultCaseOwner','defaultCaseOwnerType','defaultCaseUser','emailActionDefaultsHandlerClass','emailToCase','enableCaseFeed','enableDraftEmails','enableEarlyEscalationRuleTriggers','enableEmailActionDefaultsHandler','enableSuggestedArticlesApplication','enableSuggestedArticlesCustomerPortal','enableSuggestedArticlesPartnerPortal','enableSuggestedSolutions','keepRecordTypeOnAssignmentRule','notifyContactOnCaseComment','notifyDefaultCaseOwner','notifyOwnerOnCaseComment','notifyOwnerOnCaseOwnerChange','showEmailAttachmentsInCaseAttachmentsRL','showFewerCloseActions','systemUserEmail','useSystemEmailAddress','useSystemUserAsDefaultCaseUser','webToCase'),
    "CaseSubjectParticle"=c('fullName','index','textField','type'),
    "Certificate"=c('content','caSigned','encryptedWithPlatformEncryption','expirationDate','keySize','masterLabel','privateKeyExportable'),
    "ChannelLayout"=c('fullName','enabledChannels','label','layoutItems','recordType'),
    "ChannelLayoutItem"=c('field'),
    "ChartSummary"=c('aggregate','axisBinding','column'),
    "ChatterAnswersReputationLevel"=c('name','value'),
    "ChatterAnswersSettings"=c('fullName','emailFollowersOnBestAnswer','emailFollowersOnReply','emailOwnerOnPrivateReply','emailOwnerOnReply','enableAnswerViaEmail','enableChatterAnswers','enableFacebookSSO','enableInlinePublisher','enableReputation','enableRichTextEditor','facebookAuthProvider','showInPortals'),
    "ChatterExtension"=c('fullName','compositionComponent','description','extensionName','headerText','hoverText','icon','isProtected','masterLabel','renderComponent','type'),
    "ChatterMobileSettings"=c('enablePushNotifications'),
    "CleanDataService"=c('fullName','cleanRules','description','masterLabel','matchEngine'),
    "CleanRule"=c('bulkEnabled','bypassTriggers','bypassWorkflow','description','developerName','fieldMappings','masterLabel','matchRule','sourceSobjectType','status','targetSobjectType'),
    "CodeLocation"=c('column','line','numExecutions','time'),
    "Community"=c('fullName','active','chatterAnswersFacebookSsoUrl','communityFeedPage','dataCategoryName','description','emailFooterDocument','emailHeaderDocument','emailNotificationUrl','enableChatterAnswers','enablePrivateQuestions','expertsGroup','portal','reputationLevels','showInPortal','site'),
    "CommunityCustomThemeLayoutType"=c('description','label'),
    "CommunityRoles"=c('customerUserRole','employeeUserRole','partnerUserRole'),
    "CommunityTemplateBundleInfo"=c('description','image','order','title','type'),
    "CommunityTemplateDefinition"=c('fullName','baseTemplate','bundlesInfo','category','defaultBrandingSet','defaultThemeDefinition','description','enableExtendedCleanUpOnDelete','masterLabel','navigationLinkSet','pageSetting'),
    "CommunityTemplatePageSetting"=c('page','themeLayout'),
    "CommunityThemeDefinition"=c('fullName','customThemeLayoutType','description','enableExtendedCleanUpOnDelete','masterLabel','themeSetting'),
    "CommunityThemeSetting"=c('customThemeLayoutType','themeLayout','themeLayoutType'),
    "CompactLayout"=c('fullName','fields','label'),
    "CompanySettings"=c('fullName','fiscalYear'),
    "ComponentInstance"=c('componentInstanceProperties','componentName','visibilityRule'),
    "ComponentInstanceProperty"=c('name','type','value'),
    "ConnectedApp"=c('fullName','attributes','canvasConfig','contactEmail','contactPhone','description','iconUrl','infoUrl','ipRanges','label','logoUrl','mobileAppConfig','mobileStartUrl','oauthConfig','plugin','samlConfig','startUrl'),
    "ConnectedAppAttribute"=c('formula','key'),
    "ConnectedAppCanvasConfig"=c('accessMethod','canvasUrl','lifecycleClass','locations','options','samlInitiationMethod'),
    "ConnectedAppIpRange"=c('description','end','start'),
    "ConnectedAppMobileDetailConfig"=c('applicationBinaryFile','applicationBinaryFileName','applicationBundleIdentifier','applicationFileLength','applicationIconFile','applicationIconFileName','applicationInstallUrl','devicePlatform','deviceType','minimumOsVersion','privateApp','version'),
    "ConnectedAppOauthConfig"=c('callbackUrl','certificate','consumerKey','consumerSecret','scopes','singleLogoutUrl'),
    "ConnectedAppSamlConfig"=c('acsUrl','certificate','encryptionCertificate','encryptionType','entityUrl','issuer','samlIdpSLOBindingEnum','samlNameIdFormat','samlSloUrl','samlSubjectCustomAttr','samlSubjectType'),
    "Container"=c('height','isContainerAutoSizeEnabled','region','sidebarComponents','style','unit','width'),
    "ContentAsset"=c('content','format','language','masterLabel','originNetwork','relationships','versions'),
    "ContentAssetLink"=c('access','isManagingWorkspace','name'),
    "ContentAssetRelationships"=c('insightsApplication','network','organization','workspace'),
    "ContentAssetVersion"=c('number','pathOnClient','zipEntry'),
    "ContentAssetVersions"=c('version'),
    "ContractSettings"=c('fullName','autoCalculateEndDate','autoExpirationDelay','autoExpirationRecipient','autoExpireContracts','enableContractHistoryTracking','notifyOwnersOnContractExpiration'),
    "CorsWhitelistOrigin"=c('fullName','urlPattern'),
    "CountriesAndStates"=c('countries'),
    "Country"=c('active','integrationValue','isoCode','label','orgDefault','standard','states','visible'),
    "CspTrustedSite"=c('fullName','description','endpointUrl','isActive'),
    "CustomApplication"=c('fullName','actionOverrides','brand','consoleConfig','defaultLandingTab','description','formFactors','isServiceCloudConsole','label','logo','navType','preferences','profileActionOverrides','setupExperience','subscriberTabs','tabs','uiType','utilityBar','workspaceConfig'),
    "CustomApplicationComponent"=c('fullName','buttonIconUrl','buttonStyle','buttonText','buttonWidth','height','isHeightFixed','isHidden','isWidthFixed','visualforcePage','width'),
    "CustomApplicationTranslation"=c('label','name'),
    "CustomConsoleComponents"=c('primaryTabComponents','subtabComponents'),
    "CustomDataType"=c('fullName','customDataTypeComponents','description','displayFormula','editComponentsOnSeparateLines','label','rightAligned','supportComponentsInReports'),
    "CustomDataTypeComponent"=c('developerSuffix','enforceFieldRequiredness','label','length','precision','scale','sortOrder','sortPriority','type'),
    "CustomDataTypeComponentTranslation"=c('developerSuffix','label'),
    "CustomDataTypeTranslation"=c('components','customDataTypeName','description','label'),
    "CustomExperience"=c('fullName','allowInternalUserLogin','branding','changePasswordEmailTemplate','emailFooterLogo','emailFooterText','emailSenderAddress','emailSenderName','enableErrorPageOverridesForVisualforce','forgotPasswordEmailTemplate','picassoSite','sObjectType','sendWelcomeEmail','site','siteAsContainerEnabled','tabs','urlPathPrefix','welcomeEmailTemplate'),
    "CustomExperienceBranding"=c('loginFooterText','loginLogo','pageFooter','pageHeader','primaryColor','primaryComplementColor','quaternaryColor','quaternaryComplementColor','secondaryColor','tertiaryColor','tertiaryComplementColor','zeronaryColor','zeronaryComplementColor'),
    "CustomExperienceTabSet"=c('customTab','defaultTab','standardTab'),
    "CustomFeedFilter"=c('fullName','criteria','description','isProtected','label'),
    "CustomField"=c('fullName','businessOwnerGroup','businessOwnerUser','businessStatus','caseSensitive','customDataType','defaultValue','deleteConstraint','deprecated','description','displayFormat','encrypted','escapeMarkup','externalDeveloperName','externalId','fieldManageability','formula','formulaTreatBlanksAs','inlineHelpText','isConvertLeadDisabled','isFilteringDisabled','isNameField','isSortingDisabled','label','length','lookupFilter','maskChar','maskType','metadataRelationshipControllingField','populateExistingRows','precision','referenceTargetField','referenceTo','relationshipLabel','relationshipName','relationshipOrder','reparentableMasterDetail','required','restrictedAdminField','scale','securityClassification','startingNumber','stripMarkup','summarizedField','summaryFilterItems','summaryForeignKey','summaryOperation','trackFeedHistory','trackHistory','trackTrending','type','unique','valueSet','visibleLines','writeRequiresMasterRead'),
    "CustomFieldTranslation"=c('caseValues','gender','help','label','lookupFilter','name','picklistValues','relationshipLabel','startsWith'),
    "CustomLabel"=c('fullName','categories','language','protected','shortDescription','value'),
    "CustomLabels"=c('fullName','labels'),
    "CustomLabelTranslation"=c('label','name'),
    "CustomMetadata"=c('fullName','description','label','protected','values'),
    "CustomMetadataValue"=c('field','value'),
    "CustomNotificationType"=c('fullName','customNotifTypeName','description','desktop','email','masterLabel','mobile'),
    "CustomObject"=c('fullName','actionOverrides','allowInChatterGroups','articleTypeChannelDisplay','businessProcesses','compactLayoutAssignment','compactLayouts','customHelp','customHelpPage','customSettingsType','dataStewardGroup','dataStewardUser','deploymentStatus','deprecated','description','enableActivities','enableBulkApi','enableChangeDataCapture','enableDivisions','enableEnhancedLookup','enableFeeds','enableHistory','enableReports','enableSearch','enableSharing','enableStreamingApi','eventType','externalDataSource','externalName','externalRepository','externalSharingModel','fieldSets','fields','gender','historyRetentionPolicy','household','indexes','label','listViews','nameField','pluralLabel','recordTypeTrackFeedHistory','recordTypeTrackHistory','recordTypes','searchLayouts','sharingModel','sharingReasons','sharingRecalculations','startsWith','validationRules','visibility','webLinks'),
    "CustomObjectTranslation"=c('fullName','caseValues','fieldSets','fields','gender','layouts','nameFieldLabel','quickActions','recordTypes','sharingReasons','standardFields','startsWith','validationRules','webLinks','workflowTasks'),
    "CustomPageWebLink"=c('fullName','availability','description','displayType','encodingKey','hasMenubar','hasScrollbars','hasToolbar','height','isResizable','linkType','masterLabel','openType','page','position','protected','requireRowSelection','scontrol','showsLocation','showsStatus','url','width'),
    "CustomPageWebLinkTranslation"=c('label','name'),
    "CustomPermission"=c('fullName','connectedApp','description','label','requiredPermission'),
    "CustomPermissionDependencyRequired"=c('customPermission','dependency'),
    "CustomShortcut"=c('action','active','keyCommand','description','eventName'),
    "CustomSite"=c('fullName','active','allowHomePage','allowStandardAnswersPages','allowStandardIdeasPages','allowStandardLookups','allowStandardPortalPages','allowStandardSearch','analyticsTrackingCode','authorizationRequiredPage','bandwidthExceededPage','browserXssProtection','changePasswordPage','chatterAnswersForgotPasswordConfirmPage','chatterAnswersForgotPasswordPage','chatterAnswersHelpPage','chatterAnswersLoginPage','chatterAnswersRegistrationPage','clickjackProtectionLevel','contentSniffingProtection','cspUpgradeInsecureRequests','customWebAddresses','description','favoriteIcon','fileNotFoundPage','forgotPasswordPage','genericErrorPage','guestProfile','inMaintenancePage','inactiveIndexPage','indexPage','masterLabel','myProfilePage','portal','referrerPolicyOriginWhenCrossOrigin','requireHttps','requireInsecurePortalAccess','robotsTxtPage','rootComponent','selfRegPage','serverIsDown','siteAdmin','siteRedirectMappings','siteTemplate','siteType','subdomain','urlPathPrefix'),
    "CustomTab"=c('fullName','actionOverrides','auraComponent','customObject','description','flexiPage','frameHeight','hasSidebar','icon','label','mobileReady','motif','page','scontrol','splashPageLink','url','urlEncodingKey'),
    "CustomTabTranslation"=c('label','name'),
    "CustomValue"=c('fullName','color','default','description','isActive','label'),
    "Dashboard"=c('fullName','backgroundEndColor','backgroundFadeDirection','backgroundStartColor','chartTheme','colorPalette','dashboardChartTheme','dashboardColorPalette','dashboardFilters','dashboardGridLayout','dashboardResultRefreshedDate','dashboardResultRunningUser','dashboardType','description','folderName','isGridLayout','leftSection','middleSection','numSubscriptions','rightSection','runningUser','textColor','title','titleColor','titleSize'),
    "DashboardComponent"=c('autoselectColumnsFromReport','chartAxisRange','chartAxisRangeMax','chartAxisRangeMin','chartSummary','componentChartTheme','componentType','dashboardFilterColumns','dashboardTableColumn','displayUnits','drillDownUrl','drillEnabled','drillToDetailEnabled','enableHover','expandOthers','flexComponentProperties','footer','gaugeMax','gaugeMin','groupingColumn','header','indicatorBreakpoint1','indicatorBreakpoint2','indicatorHighColor','indicatorLowColor','indicatorMiddleColor','legendPosition','maxValuesDisplayed','metricLabel','page','pageHeightInPixels','report','scontrol','scontrolHeightInPixels','showPercentage','showPicturesOnCharts','showPicturesOnTables','showRange','showTotal','showValues','sortBy','title','useReportChart'),
    "DashboardComponentColumn"=c('breakPoint1','breakPoint2','breakPointOrder','highRangeColor','lowRangeColor','midRangeColor','reportColumn','showTotal','type'),
    "DashboardComponentSection"=c('columnSize','components'),
    "DashboardComponentSortInfo"=c('sortColumn','sortOrder'),
    "DashboardFilter"=c('dashboardFilterOptions','name'),
    "DashboardFilterColumn"=c('column'),
    "DashboardFilterOption"=c('operator','values'),
    "DashboardFlexTableComponentProperties"=c('flexTableColumn','flexTableSortInfo','hideChatterPhotos'),
    "DashboardFolder"=c('accessType','folderShares','name','publicFolderAccess','sharedTo'),
    "DashboardGridComponent"=c('colSpan','columnIndex','dashboardComponent','rowIndex','rowSpan'),
    "DashboardGridLayout"=c('dashboardGridComponents','numberOfColumns','rowHeight'),
    "DashboardMobileSettings"=c('enableDashboardIPadApp'),
    "DashboardTableColumn"=c('aggregateType','calculatePercent','column','decimalPlaces','showTotal','sortBy'),
    "DataCategory"=c('dataCategory','label','name'),
    "DataCategoryGroup"=c('fullName','active','dataCategory','description','label','objectUsage'),
    "DataPipeline"=c('content','apiVersion','label','scriptType'),
    "DefaultShortcut"=c('action','active','keyCommand'),
    "DelegateGroup"=c('fullName','customObjects','groups','label','loginAccess','permissionSets','profiles','roles'),
    "DeployDetails"=c('componentFailures','componentSuccesses','retrieveResult','runTestResult'),
    "DeployOptions"=c('allowMissingFiles','autoUpdatePackage','checkOnly','ignoreWarnings','performRetrieve','purgeOnDelete','rollbackOnError','runTests','singlePackage','testLevel'),
    "DescribeMetadataObject"=c('childXmlNames','directoryName','inFolder','metaFile','suffix','xmlName'),
    "Document"=c('content','description','internalUseOnly','keywords','name','public'),
    "DocumentFolder"=c('accessType','folderShares','name','publicFolderAccess','sharedTo'),
    "DuplicateRule"=c('fullName','actionOnInsert','actionOnUpdate','alertText','description','duplicateRuleFilter','duplicateRuleMatchRules','isActive','masterLabel','operationsOnInsert','operationsOnUpdate','securityOption','sortOrder'),
    "DuplicateRuleFilter"=c('booleanFilter','duplicateRuleFilterItems'),
    "DuplicateRuleFilterItem"=c('field','operation','value','valueField','sortOrder','table'),
    "DuplicateRuleMatchRule"=c('matchRuleSObjectType','matchingRule','objectMapping'),
    "EclairGeoData"=c('content','maps','masterLabel'),
    "EclairMap"=c('boundingBoxBottom','boundingBoxLeft','boundingBoxRight','boundingBoxTop','mapLabel','mapName','projection'),
    "EmailFolder"=c('accessType','folderShares','name','publicFolderAccess','sharedTo'),
    "EmailServicesAddress"=c('authorizedSenders','developerName','isActive','localPart','runAsUser'),
    "EmailServicesFunction"=c('fullName','apexClass','attachmentOption','authenticationFailureAction','authorizationFailureAction','authorizedSenders','emailServicesAddresses','errorRoutingAddress','functionInactiveAction','functionName','isActive','isAuthenticationRequired','isErrorRoutingEnabled','isTextAttachmentsAsBinary','isTlsRequired','overLimitAction'),
    "EmailTemplate"=c('content','apiVersion','attachedDocuments','attachments','available','description','encodingKey','letterhead','name','packageVersions','relatedEntityType','style','subject','textOnly','type','uiType'),
    "EmailToCaseRoutingAddress"=c('addressType','authorizedSenders','caseOrigin','caseOwner','caseOwnerType','casePriority','createTask','emailAddress','emailServicesAddress','isVerified','routingName','saveEmailHeaders','taskStatus'),
    "EmailToCaseSettings"=c('enableE2CSourceTracking','enableEmailToCase','enableHtmlEmail','enableOnDemandEmailToCase','enableThreadIDInBody','enableThreadIDInSubject','notifyOwnerOnNewCaseEmail','overEmailLimitAction','preQuoteSignature','routingAddresses','unauthorizedSenderAction'),
    "EmbeddedServiceBranding"=c('fullName','contrastInvertedColor','contrastPrimaryColor','embeddedServiceConfig','font','masterLabel','navBarColor','primaryColor','secondaryColor'),
    "EmbeddedServiceConfig"=c('fullName','masterLabel','site'),
    "EmbeddedServiceFieldService"=c('fullName','appointmentBookingFlowName','cancelApptBookingFlowName','embeddedServiceConfig','enabled','fieldServiceConfirmCardImg','fieldServiceHomeImg','fieldServiceLogoImg','masterLabel','modifyApptBookingFlowName','shouldShowExistingAppointment','shouldShowNewAppointment'),
    "EmbeddedServiceLiveAgent"=c('fullName','avatarImg','customPrechatComponent','embeddedServiceConfig','embeddedServiceQuickActions','enabled','fontSize','headerBackgroundImg','liveAgentChatUrl','liveAgentContentUrl','liveChatButton','liveChatDeployment','masterLabel','prechatBackgroundImg','prechatEnabled','prechatJson','scenario','smallCompanyLogoImg','waitingStateBackgroundImg'),
    "EmbeddedServiceQuickAction"=c('embeddedServiceLiveAgent','order','quickActionDefinition'),
    "EntitlementProcess"=c('fullName','SObjectType','active','businessHours','description','entryStartDateField','exitCriteriaBooleanFilter','exitCriteriaFilterItems','exitCriteriaFormula','isRecordTypeApplied','isVersionDefault','milestones','name','recordType','versionMaster','versionNotes','versionNumber'),
    "EntitlementProcessMilestoneItem"=c('businessHours','criteriaBooleanFilter','milestoneCriteriaFilterItems','milestoneCriteriaFormula','milestoneName','minutesCustomClass','minutesToComplete','successActions','timeTriggers','useCriteriaStartTime'),
    "EntitlementProcessMilestoneTimeTrigger"=c('actions','timeLength','workflowTimeTriggerUnit'),
    "EntitlementSettings"=c('fullName','assetLookupLimitedToActiveEntitlementsOnAccount','assetLookupLimitedToActiveEntitlementsOnContact','assetLookupLimitedToSameAccount','assetLookupLimitedToSameContact','enableEntitlementVersioning','enableEntitlements','entitlementLookupLimitedToActiveStatus','entitlementLookupLimitedToSameAccount','entitlementLookupLimitedToSameAsset','entitlementLookupLimitedToSameContact'),
    "EntitlementTemplate"=c('fullName','businessHours','casesPerEntitlement','entitlementProcess','isPerIncident','term','type'),
    "EscalationAction"=c('assignedTo','assignedToTemplate','assignedToType','minutesToEscalation','notifyCaseOwner','notifyEmail','notifyTo','notifyToTemplate'),
    "EscalationRule"=c('fullName','active','ruleEntry'),
    "EscalationRules"=c('fullName','escalationRule'),
    "EventDelivery"=c('fullName','eventParameters','eventSubscription','referenceData','type'),
    "EventParameterMap"=c('parameterName','parameterValue'),
    "EventSubscription"=c('fullName','active','eventParameters','eventType','referenceData'),
    "ExtendedErrorDetails"=c('extendedErrorCode'),
    "ExternalDataSource"=c('fullName','authProvider','certificate','customConfiguration','endpoint','isWritable','label','oauthRefreshToken','oauthScope','oauthToken','password','principalType','protocol','repository','type','username','version'),
    "ExternalServiceRegistration"=c('fullName','description','label','namedCredential','schema','schemaType','schemaUrl','status'),
    "FeedFilterCriterion"=c('feedItemType','feedItemVisibility','relatedSObjectType'),
    "FeedItemSettings"=c('characterLimit','collapseThread','displayFormat','feedItemType'),
    "FeedLayout"=c('autocollapsePublisher','compactFeed','feedFilterPosition','feedFilters','fullWidthFeed','hideSidebar','highlightExternalFeedItems','leftComponents','rightComponents','useInlineFiltersInConsole'),
    "FeedLayoutComponent"=c('componentType','height','page'),
    "FeedLayoutFilter"=c('feedFilterName','feedFilterType','feedItemType'),
    "FieldMapping"=c('SObjectType','developerName','fieldMappingRows','masterLabel'),
    "FieldMappingField"=c('dataServiceField','dataServiceObjectName','priority'),
    "FieldMappingRow"=c('SObjectType','fieldMappingFields','fieldName','mappingOperation'),
    "FieldOverride"=c('field','formula','literalValue'),
    "FieldServiceSettings"=c('fullName','fieldServiceNotificationsOrgPref','fieldServiceOrgPref','serviceAppointmentsDueDateOffsetOrgValue','workOrderLineItemSearchFields','workOrderSearchFields'),
    "FieldSet"=c('fullName','availableFields','description','displayedFields','label'),
    "FieldSetItem"=c('field','isFieldManaged','isRequired'),
    "FieldSetTranslation"=c('label','name'),
    "FieldValue"=c('name','value'),
    "FileProperties"=c('createdById','createdByName','createdDate','fileName','fullName','id','lastModifiedById','lastModifiedByName','lastModifiedDate','manageableState','namespacePrefix','type'),
    "FileTypeDispositionAssignmentBean"=c('behavior','fileType','securityRiskFileType'),
    "FileUploadAndDownloadSecuritySettings"=c('fullName','dispositions','noHtmlUploadAsAttachment'),
    "FilterItem"=c('field','operation','value','valueField'),
    "FindSimilarOppFilter"=c('similarOpportunitiesDisplayColumns','similarOpportunitiesMatchFields'),
    "FiscalYearSettings"=c('fiscalYearNameBasedOn','startMonth'),
    "FlexiPage"=c('fullName','description','flexiPageRegions','masterLabel','parentFlexiPage','platformActionlist','quickActionList','sobjectType','template','type'),
    "FlexiPageRegion"=c('appendable','componentInstances','mode','name','prependable','replaceable','type'),
    "FlexiPageTemplateInstance"=c('name','properties'),
    "Flow"=c('fullName','actionCalls','apexPluginCalls','assignments','choices','constants','decisions','description','dynamicChoiceSets','formulas','interviewLabel','label','loops','processMetadataValues','processType','recordCreates','recordDeletes','recordLookups','recordUpdates','screens','stages','startElementReference','steps','subflows','textTemplates','variables','waits'),
    "FlowActionCall"=c('label','locationX','locationY','actionName','actionType','connector','faultConnector','inputParameters','outputParameters'),
    "FlowActionCallInputParameter"=c('processMetadataValues','name','value'),
    "FlowActionCallOutputParameter"=c('processMetadataValues','assignToReference','name'),
    "FlowApexPluginCall"=c('label','locationX','locationY','apexClass','connector','faultConnector','inputParameters','outputParameters'),
    "FlowApexPluginCallInputParameter"=c('processMetadataValues','name','value'),
    "FlowApexPluginCallOutputParameter"=c('processMetadataValues','assignToReference','name'),
    "FlowAssignment"=c('label','locationX','locationY','assignmentItems','connector'),
    "FlowAssignmentItem"=c('processMetadataValues','assignToReference','operator','value'),
    "FlowBaseElement"=c('processMetadataValues'),
    "FlowCategory"=c('fullName','description','flowCategoryItems','masterLabel'),
    "FlowCategoryItems"=c('flow'),
    "FlowChoice"=c('description','name','choiceText','dataType','userInput','value'),
    "FlowChoiceTranslation"=c('choiceText','name','userInput'),
    "FlowChoiceUserInput"=c('processMetadataValues','isRequired','promptText','validationRule'),
    "FlowChoiceUserInputTranslation"=c('promptText','validationRule'),
    "FlowCondition"=c('processMetadataValues','leftValueReference','operator','rightValue'),
    "FlowConnector"=c('processMetadataValues','targetReference'),
    "FlowConstant"=c('description','name','dataType','value'),
    "FlowDecision"=c('label','locationX','locationY','defaultConnector','defaultConnectorLabel','rules'),
    "FlowDefinition"=c('fullName','activeVersionNumber','description','masterLabel'),
    "FlowDefinitionTranslation"=c('flows','fullName','label'),
    "FlowDynamicChoiceSet"=c('description','name','dataType','displayField','filters','limit','object','outputAssignments','picklistField','picklistObject','sortField','sortOrder','valueField'),
    "FlowElement"=c('processMetadataValues','description','name'),
    "FlowElementReferenceOrValue"=c('booleanValue','dateTimeValue','dateValue','elementReference','numberValue','stringValue'),
    "FlowFormula"=c('description','name','dataType','expression','scale'),
    "FlowInputFieldAssignment"=c('processMetadataValues','field','value'),
    "FlowInputValidationRule"=c('errorMessage','formulaExpression'),
    "FlowInputValidationRuleTranslation"=c('errorMessage'),
    "FlowLoop"=c('label','locationX','locationY','assignNextValueToReference','collectionReference','iterationOrder','nextValueConnector','noMoreValuesConnector'),
    "FlowMetadataValue"=c('name','value'),
    "FlowNode"=c('description','name','label','locationX','locationY'),
    "FlowOutputFieldAssignment"=c('processMetadataValues','assignToReference','field'),
    "FlowRecordCreate"=c('label','locationX','locationY','assignRecordIdToReference','connector','faultConnector','inputAssignments','inputReference','object'),
    "FlowRecordDelete"=c('label','locationX','locationY','connector','faultConnector','filters','inputReference','object'),
    "FlowRecordFilter"=c('processMetadataValues','field','operator','value'),
    "FlowRecordLookup"=c('label','locationX','locationY','assignNullValuesIfNoRecordsFound','connector','faultConnector','filters','object','outputAssignments','outputReference','queriedFields','sortField','sortOrder'),
    "FlowRecordUpdate"=c('label','locationX','locationY','connector','faultConnector','filters','inputAssignments','inputReference','object'),
    "FlowRule"=c('description','name','conditionLogic','conditions','connector','label'),
    "FlowScreen"=c('label','locationX','locationY','allowBack','allowFinish','allowPause','connector','fields','helpText','pausedText','rules','showFooter','showHeader'),
    "FlowScreenField"=c('description','name','choiceReferences','dataType','defaultSelectedChoiceReference','defaultValue','extensionName','fieldText','fieldType','helpText','inputParameters','isRequired','isVisible','outputParameters','scale','validationRule'),
    "FlowScreenFieldInputParameter"=c('processMetadataValues','name','value'),
    "FlowScreenFieldOutputParameter"=c('processMetadataValues','assignToReference','name'),
    "FlowScreenFieldTranslation"=c('fieldText','helpText','name','validationRule'),
    "FlowScreenRule"=c('processMetadataValues','conditionLogic','conditions','label','ruleActions'),
    "FlowScreenRuleAction"=c('processMetadataValues','attribute','fieldReference','value'),
    "FlowScreenTranslation"=c('fields','helpText','name','pausedText'),
    "FlowStage"=c('description','name','isActive','label','stageOrder'),
    "FlowStep"=c('label','locationX','locationY','connectors'),
    "FlowSubflow"=c('label','locationX','locationY','connector','flowName','inputAssignments','outputAssignments'),
    "FlowSubflowInputAssignment"=c('processMetadataValues','name','value'),
    "FlowSubflowOutputAssignment"=c('processMetadataValues','assignToReference','name'),
    "FlowTextTemplate"=c('description','name','text'),
    "FlowTranslation"=c('choices','fullName','label','screens'),
    "FlowVariable"=c('description','name','dataType','isCollection','isInput','isOutput','objectType','scale','value'),
    "FlowWait"=c('label','locationX','locationY','defaultConnector','defaultConnectorLabel','faultConnector','waitEvents'),
    "FlowWaitEvent"=c('description','name','conditionLogic','conditions','connector','eventType','inputParameters','label','outputParameters'),
    "FlowWaitEventInputParameter"=c('processMetadataValues','name','value'),
    "FlowWaitEventOutputParameter"=c('processMetadataValues','assignToReference','name'),
    "Folder"=c('fullName','accessType','folderShares','name','publicFolderAccess','sharedTo'),
    "FolderShare"=c('accessLevel','sharedTo','sharedToType'),
    "ForecastingCategoryMapping"=c('forecastingItemCategoryApiName','weightedSourceCategories'),
    "ForecastingDisplayedFamilySettings"=c('productFamily'),
    "ForecastingSettings"=c('fullName','displayCurrency','enableForecasts','forecastingCategoryMappings','forecastingDisplayedFamilySettings','forecastingTypeSettings'),
    "ForecastingTypeSettings"=c('active','adjustmentsSettings','displayedCategoryApiNames','forecastRangeSettings','forecastedCategoryApiNames','forecastingDateType','hasProductFamily','isAmount','isAvailable','isQuantity','managerAdjustableCategoryApiNames','masterLabel','name','opportunityListFieldsLabelMappings','opportunityListFieldsSelectedSettings','opportunityListFieldsUnselectedSettings','opportunitySplitName','ownerAdjustableCategoryApiNames','quotasSettings','territory2ModelName'),
    "ForecastRangeSettings"=c('beginning','displaying','periodType'),
    "GlobalPicklistValue"=c('fullName','color','default','description','isActive'),
    "GlobalQuickActionTranslation"=c('label','name'),
    "GlobalValueSet"=c('fullName','customValue','description','masterLabel','sorted'),
    "GlobalValueSetTranslation"=c('fullName','valueTranslation'),
    "Group"=c('fullName','doesIncludeBosses','name'),
    "HistoryRetentionPolicy"=c('archiveAfterMonths','archiveRetentionYears','description'),
    "Holiday"=c('activityDate','businessHours','description','endTime','isRecurring','name','recurrenceDayOfMonth','recurrenceDayOfWeek','recurrenceDayOfWeekMask','recurrenceEndDate','recurrenceInstance','recurrenceInterval','recurrenceMonthOfYear','recurrenceStartDate','recurrenceType','startTime'),
    "HomePageComponent"=c('fullName','body','height','links','page','pageComponentType','showLabel','showScrollbars','width'),
    "HomePageLayout"=c('fullName','narrowComponents','wideComponents'),
    "IdeaReputationLevel"=c('name','value'),
    "IdeasSettings"=c('fullName','enableChatterProfile','enableIdeaThemes','enableIdeas','enableIdeasReputation','halfLife','ideasProfilePage'),
    "Index"=c('fullName','fields','label'),
    "IndexField"=c('name','sortDirection'),
    "InsightType"=c('fullName','defaultTrendType','description','isProtected','masterLabel','parentType','title'),
    "InstalledPackage"=c('fullName','password','versionNumber'),
    "IntegrationHubSettings"=c('fullName','canonicalName','canonicalNameBindingChar','description','isEnabled','isProtected','masterLabel','setupData','setupDefinition','setupNamespace','setupSimpleName','uUID','version','versionBuild','versionMajor','versionMinor'),
    "IntegrationHubSettingsType"=c('fullName','canonicalName','canonicalNameBindingChar','description','isEnabled','isProtected','masterLabel','setupNamespace','setupSimpleName','uUID','version','versionBuild','versionMajor','versionMinor'),
    "IpRange"=c('description','end','start'),
    "KeyboardShortcuts"=c('customShortcuts','defaultShortcuts'),
    "Keyword"=c('keyword'),
    "KeywordList"=c('fullName','description','keywords','masterLabel'),
    "KnowledgeAnswerSettings"=c('assignTo','defaultArticleType','enableArticleCreation'),
    "KnowledgeCaseField"=c('name'),
    "KnowledgeCaseFieldsSettings"=c('field'),
    "KnowledgeCaseSettings"=c('articlePDFCreationProfile','articlePublicSharingCommunities','articlePublicSharingSites','articlePublicSharingSitesChatterAnswers','assignTo','customizationClass','defaultContributionArticleType','editor','enableArticleCreation','enableArticlePublicSharingSites','enableCaseDataCategoryMapping','useProfileForPDFCreation'),
    "KnowledgeCommunitiesSettings"=c('community'),
    "KnowledgeLanguage"=c('active','defaultAssignee','defaultAssigneeType','defaultReviewer','defaultReviewerType','name'),
    "KnowledgeLanguageSettings"=c('language'),
    "KnowledgeSettings"=c('fullName','answers','cases','defaultLanguage','enableChatterQuestionKBDeflection','enableCreateEditOnArticlesTab','enableExternalMediaContent','enableKnowledge','enableLightningKnowledge','languages','showArticleSummariesCustomerPortal','showArticleSummariesInternalApp','showArticleSummariesPartnerPortal','showValidationStatusField','suggestedArticles'),
    "KnowledgeSitesSettings"=c('site'),
    "KnowledgeSuggestedArticlesSettings"=c('caseFields','useSuggestedArticlesForCase','workOrderFields','workOrderLineItemFields'),
    "KnowledgeWorkOrderField"=c('name'),
    "KnowledgeWorkOrderFieldsSettings"=c('field'),
    "KnowledgeWorkOrderLineItemField"=c('name'),
    "KnowledgeWorkOrderLineItemFieldsSettings"=c('field'),
    "Layout"=c('fullName','customButtons','customConsoleComponents','emailDefault','excludeButtons','feedLayout','headers','layoutSections','miniLayout','multilineLayoutFields','platformActionList','quickActionList','relatedContent','relatedLists','relatedObjects','runAssignmentRulesDefault','showEmailCheckbox','showHighlightsPanel','showInteractionLogPanel','showKnowledgeComponent','showRunAssignmentRulesCheckbox','showSolutionSection','showSubmitAndAttachButton','summaryLayout'),
    "LayoutColumn"=c('layoutItems','reserved'),
    "LayoutItem"=c('analyticsCloudComponent','behavior','canvas','component','customLink','emptySpace','field','height','page','reportChartComponent','scontrol','showLabel','showScrollbars','width'),
    "LayoutSection"=c('customLabel','detailHeading','editHeading','label','layoutColumns','style'),
    "LayoutSectionTranslation"=c('label','section'),
    "LayoutTranslation"=c('layout','layoutType','sections'),
    "LeadConvertSettings"=c('fullName','allowOwnerChange','objectMapping','opportunityCreationOptions'),
    "Letterhead"=c('fullName','available','backgroundColor','bodyColor','bottomLine','description','footer','header','middleLine','name','topLine'),
    "LetterheadHeaderFooter"=c('backgroundColor','height','horizontalAlignment','logo','verticalAlignment'),
    "LetterheadLine"=c('color','height'),
    "LicensedCustomPermissions"=c('customPermission','licenseDefinition'),
    "LicenseDefinition"=c('fullName','aggregationGroup','description','isPublished','label','licensedCustomPermissions','licensingAuthority','licensingAuthorityProvider','minPlatformVersion','origin','revision','trialLicenseDuration','trialLicenseQuantity'),
    "LightningBolt"=c('fullName','category','lightningBoltFeatures','lightningBoltImages','lightningBoltItems','masterLabel','publisher','summary'),
    "LightningBoltFeatures"=c('description','order','title'),
    "LightningBoltImages"=c('image','order'),
    "LightningBoltItems"=c('name','type'),
    "LightningComponentBundle"=c('fullName','apiVersion','isExposed'),
    "LightningExperienceTheme"=c('fullName','defaultBrandingSet','description','masterLabel','shouldOverrideLoadingImage'),
    "ListMetadataQuery"=c('folder','type'),
    "ListPlacement"=c('height','location','units','width'),
    "ListView"=c('fullName','booleanFilter','columns','division','filterScope','filters','label','language','queue','sharedTo'),
    "ListViewFilter"=c('field','operation','value'),
    "LiveAgentConfig"=c('enableLiveChat','openNewAccountSubtab','openNewCaseSubtab','openNewContactSubtab','openNewLeadSubtab','openNewVFPageSubtab','pageNamesToOpen','showKnowledgeArticles'),
    "LiveAgentSettings"=c('fullName','enableLiveAgent'),
    "LiveChatAgentConfig"=c('fullName','assignments','autoGreeting','capacity','criticalWaitTime','customAgentName','enableAgentFileTransfer','enableAgentSneakPeek','enableAssistanceFlag','enableAutoAwayOnDecline','enableAutoAwayOnPushTimeout','enableChatConferencing','enableChatMonitoring','enableChatTransferToAgent','enableChatTransferToButton','enableChatTransferToSkill','enableLogoutSound','enableNotifications','enableRequestSound','enableSneakPeek','enableVisitorBlocking','enableWhisperMessage','label','supervisorDefaultAgentStatusFilter','supervisorDefaultButtonFilter','supervisorDefaultSkillFilter','supervisorSkills','transferableButtons','transferableSkills'),
    "LiveChatButton"=c('fullName','animation','autoGreeting','chasitorIdleTimeout','chasitorIdleTimeoutWarning','chatPage','customAgentName','deployments','enableQueue','inviteEndPosition','inviteImage','inviteStartPosition','isActive','label','numberOfReroutingAttempts','offlineImage','onlineImage','optionsCustomRoutingIsEnabled','optionsHasChasitorIdleTimeout','optionsHasInviteAfterAccept','optionsHasInviteAfterReject','optionsHasRerouteDeclinedRequest','optionsIsAutoAccept','optionsIsInviteAutoRemove','overallQueueLength','perAgentQueueLength','postChatPage','postChatUrl','preChatFormPage','preChatFormUrl','pushTimeOut','routingType','site','skills','timeToRemoveInvite','type','windowLanguage'),
    "LiveChatButtonDeployments"=c('deployment'),
    "LiveChatButtonSkills"=c('skill'),
    "LiveChatDeployment"=c('fullName','brandingImage','connectionTimeoutDuration','connectionWarningDuration','displayQueuePosition','domainWhiteList','enablePrechatApi','enableTranscriptSave','label','mobileBrandingImage','site','windowTitle'),
    "LiveChatDeploymentDomainWhitelist"=c('domain'),
    "LiveChatSensitiveDataRule"=c('fullName','actionType','description','enforceOn','isEnabled','pattern','replacement'),
    "LiveMessageSettings"=c('fullName','enableLiveMessage'),
    "LogInfo"=c('category','level'),
    "LookupFilter"=c('active','booleanFilter','description','errorMessage','filterItems','infoMessage','isOptional'),
    "LookupFilterTranslation"=c('errorMessage','informationalMessage'),
    "MacroSettings"=c('fullName','enableAdvancedSearch'),
    "ManagedTopic"=c('fullName','managedTopicType','name','parentName','position','topicDescription'),
    "ManagedTopics"=c('fullName','managedTopic'),
    "MarketingActionSettings"=c('fullName','enableMarketingAction'),
    "MarketingResourceType"=c('fullName','description','masterLabel','object','provider'),
    "MatchingRule"=c('fullName','booleanFilter','description','label','matchingRuleItems','ruleStatus'),
    "MatchingRuleItem"=c('blankValueBehavior','fieldName','matchingMethod'),
    "MatchingRules"=c('fullName','matchingRules'),
    "Metadata"=c('fullName'),
    "MetadataWithContent"=c('fullName','content'),
    "MilestoneType"=c('fullName','description','recurrenceType'),
    "MiniLayout"=c('fields','relatedLists'),
    "MobileSettings"=c('fullName','chatterMobile','dashboardMobile','salesforceMobile','touchMobile'),
    "ModeratedEntityField"=c('entityName','fieldName','keywordList'),
    "ModerationRule"=c('fullName','action','actionLimit','active','description','entitiesAndFields','masterLabel','notifyLimit','timePeriod','type','userCriteria','userMessage'),
    "NamedCredential"=c('fullName','allowMergeFieldsInBody','allowMergeFieldsInHeader','authProvider','certificate','endpoint','generateAuthorizationHeader','label','oauthRefreshToken','oauthScope','oauthToken','password','principalType','protocol','username'),
    "NameSettings"=c('fullName','enableMiddleName','enableNameSuffix'),
    "NavigationLinkSet"=c('navigationMenuItem'),
    "NavigationMenuItem"=c('defaultListViewId','label','position','publiclyAvailable','subMenu','target','targetPreference','type'),
    "NavigationSubMenu"=c('navigationMenuItem'),
    "Network"=c('fullName','allowInternalUserLogin','allowMembersToFlag','allowedExtensions','caseCommentEmailTemplate','changePasswordTemplate','communityRoles','description','disableReputationRecordConversations','emailFooterLogo','emailFooterText','emailSenderAddress','emailSenderName','enableCustomVFErrorPageOverrides','enableDirectMessages','enableGuestChatter','enableGuestFileAccess','enableInvitation','enableKnowledgeable','enableNicknameDisplay','enablePrivateMessages','enableReputation','enableShowAllNetworkSettings','enableSiteAsContainer','enableTalkingAboutStats','enableTopicAssignmentRules','enableTopicSuggestions','enableUpDownVote','feedChannel','forgotPasswordTemplate','gatherCustomerSentimentData','logoutUrl','maxFileSizeKb','navigationLinkSet','networkMemberGroups','networkPageOverrides','newSenderAddress','picassoSite','recommendationAudience','recommendationDefinition','reputationLevels','reputationPointsRules','selfRegProfile','selfRegistration','sendWelcomeEmail','site','status','tabs','urlPathPrefix','welcomeTemplate'),
    "NetworkAccess"=c('ipRanges'),
    "NetworkBranding"=c('content','loginFooterText','loginLogo','loginLogoName','loginPrimaryColor','loginQuaternaryColor','loginRightFrameUrl','network','pageFooter','pageHeader','primaryColor','primaryComplementColor','quaternaryColor','quaternaryComplementColor','secondaryColor','staticLogoImageUrl','tertiaryColor','tertiaryComplementColor','zeronaryColor','zeronaryComplementColor'),
    "NetworkMemberGroup"=c('permissionSet','profile'),
    "NetworkPageOverride"=c('changePasswordPageOverrideSetting','forgotPasswordPageOverrideSetting','homePageOverrideSetting','loginPageOverrideSetting','selfRegProfilePageOverrideSetting'),
    "NetworkTabSet"=c('customTab','defaultTab','standardTab'),
    "NextAutomatedApprover"=c('useApproverFieldOfRecordOwner','userHierarchyField'),
    "ObjectMapping"=c('inputObject','mappingFields','outputObject'),
    "ObjectMappingField"=c('inputField','outputField'),
    "ObjectNameCaseValue"=c('article','caseType','plural','possessive','value'),
    "ObjectRelationship"=c('join','outerJoin','relationship'),
    "ObjectSearchSetting"=c('enhancedLookupEnabled','lookupAutoCompleteEnabled','name','resultsPerPageCount'),
    "ObjectUsage"=c('object'),
    "OpportunityListFieldsLabelMapping"=c('field','label'),
    "OpportunityListFieldsSelectedSettings"=c('field'),
    "OpportunityListFieldsUnselectedSettings"=c('field'),
    "OpportunitySettings"=c('fullName','autoActivateNewReminders','enableFindSimilarOpportunities','enableOpportunityTeam','enableUpdateReminders','findSimilarOppFilter','promptToAddProducts'),
    "Orchestration"=c('content','context','masterLabel'),
    "OrchestrationContext"=c('fullName','description','events','masterLabel','runtimeType','salesforceObject','salesforceObjectPrimaryKey'),
    "OrchestrationContextEvent"=c('eventType','orchestrationEvent','platformEvent','platformEventPrimaryKey'),
    "OrderSettings"=c('fullName','enableNegativeQuantity','enableOrders','enableReductionOrders','enableZeroQuantity'),
    "OrganizationSettingsDetail"=c('settingName','settingValue'),
    "OrgPreferenceSettings"=c('fullName','preferences'),
    "Package"=c('fullName','apiAccessLevel','description','namespacePrefix','objectPermissions','packageType','postInstallClass','setupWeblink','types','uninstallClass','version'),
    "PackageTypeMembers"=c('members','name'),
    "PackageVersion"=c('majorNumber','minorNumber','namespace'),
    "PasswordPolicies"=c('apiOnlyUserHomePageURL','complexity','expiration','historyRestriction','lockoutInterval','maxLoginAttempts','minimumPasswordLength','minimumPasswordLifetime','obscureSecretAnswer','passwordAssistanceMessage','passwordAssistanceURL','questionRestriction'),
    "PathAssistant"=c('fullName','active','entityName','fieldName','masterLabel','pathAssistantSteps','recordTypeName'),
    "PathAssistantSettings"=c('fullName','pathAssistantEnabled'),
    "PathAssistantStep"=c('fieldNames','info','picklistValueName'),
    "PermissionSet"=c('fullName','applicationVisibilities','classAccesses','customPermissions','description','externalDataSourceAccesses','fieldPermissions','hasActivationRequired','label','license','objectPermissions','pageAccesses','recordTypeVisibilities','tabSettings','userPermissions'),
    "PermissionSetApexClassAccess"=c('apexClass','enabled'),
    "PermissionSetApexPageAccess"=c('apexPage','enabled'),
    "PermissionSetApplicationVisibility"=c('application','visible'),
    "PermissionSetCustomPermissions"=c('enabled','name'),
    "PermissionSetExternalDataSourceAccess"=c('enabled','externalDataSource'),
    "PermissionSetFieldPermissions"=c('editable','field','readable'),
    "PermissionSetGroup"=c('fullName','description','isCalculatingChanges','label','permissionSets'),
    "PermissionSetObjectPermissions"=c('allowCreate','allowDelete','allowEdit','allowRead','modifyAllRecords','object','viewAllRecords'),
    "PermissionSetRecordTypeVisibility"=c('recordType','visible'),
    "PermissionSetTabSetting"=c('tab','visibility'),
    "PermissionSetUserPermission"=c('enabled','name'),
    "PersonalJourneySettings"=c('fullName','enableExactTargetForSalesforceApps'),
    "PersonListSettings"=c('fullName','enablePersonList'),
    "PicklistEntry"=c('active','defaultValue','label','validFor','value'),
    "PicklistValue"=c('color','default','description','isActive','allowEmail','closed','controllingFieldValues','converted','cssExposed','forecastCategory','highPriority','probability','reverseRole','reviewed','won'),
    "PicklistValueTranslation"=c('masterLabel','translation'),
    "PlatformActionList"=c('fullName','actionListContext','platformActionListItems','relatedSourceEntity'),
    "PlatformActionListItem"=c('actionName','actionType','sortOrder','subtype'),
    "PlatformCachePartition"=c('fullName','description','isDefaultPartition','masterLabel','platformCachePartitionTypes'),
    "PlatformCachePartitionType"=c('allocatedCapacity','allocatedPurchasedCapacity','allocatedTrialCapacity','cacheType'),
    "Portal"=c('fullName','active','admin','defaultLanguage','description','emailSenderAddress','emailSenderName','enableSelfCloseCase','footerDocument','forgotPassTemplate','headerDocument','isSelfRegistrationActivated','loginHeaderDocument','logoDocument','logoutUrl','newCommentTemplate','newPassTemplate','newUserTemplate','ownerNotifyTemplate','selfRegNewUserUrl','selfRegUserDefaultProfile','selfRegUserDefaultRole','selfRegUserTemplate','showActionConfirmation','stylesheetDocument','type'),
    "PostTemplate"=c('fullName','default','description','fields','label'),
    "PrimaryTabComponents"=c('containers'),
    "ProductSettings"=c('fullName','enableCascadeActivateToRelatedPrices','enableQuantitySchedule','enableRevenueSchedule'),
    "Profile"=c('fullName','applicationVisibilities','categoryGroupVisibilities','classAccesses','custom','customPermissions','description','externalDataSourceAccesses','fieldPermissions','layoutAssignments','loginHours','loginIpRanges','objectPermissions','pageAccesses','profileActionOverrides','recordTypeVisibilities','tabVisibilities','userLicense','userPermissions'),
    "ProfileActionOverride"=c('actionName','content','formFactor','pageOrSobjectType','recordType','type'),
    "ProfileApexClassAccess"=c('apexClass','enabled'),
    "ProfileApexPageAccess"=c('apexPage','enabled'),
    "ProfileApplicationVisibility"=c('application','default','visible'),
    "ProfileCategoryGroupVisibility"=c('dataCategories','dataCategoryGroup','visibility'),
    "ProfileCustomPermissions"=c('enabled','name'),
    "ProfileExternalDataSourceAccess"=c('enabled','externalDataSource'),
    "ProfileFieldLevelSecurity"=c('editable','field','readable'),
    "ProfileLayoutAssignment"=c('layout','recordType'),
    "ProfileLoginHours"=c('fridayEnd','fridayStart','mondayEnd','mondayStart','saturdayEnd','saturdayStart','sundayEnd','sundayStart','thursdayEnd','thursdayStart','tuesdayEnd','tuesdayStart','wednesdayEnd','wednesdayStart'),
    "ProfileLoginIpRange"=c('description','endAddress','startAddress'),
    "ProfileObjectPermissions"=c('allowCreate','allowDelete','allowEdit','allowRead','modifyAllRecords','object','viewAllRecords'),
    "ProfilePasswordPolicy"=c('fullName','lockoutInterval','maxLoginAttempts','minimumPasswordLength','minimumPasswordLifetime','obscure','passwordComplexity','passwordExpiration','passwordHistory','passwordQuestion','profile'),
    "ProfileRecordTypeVisibility"=c('default','personAccountDefault','recordType','visible'),
    "ProfileSessionSetting"=c('fullName','externalCommunityUserIdentityVerif','forceLogout','profile','requiredSessionLevel','sessionPersistence','sessionTimeout','sessionTimeoutWarning'),
    "ProfileTabVisibility"=c('tab','visibility'),
    "ProfileUserPermission"=c('enabled','name'),
    "PublicGroups"=c('publicGroup'),
    "PushNotification"=c('fieldNames','objectName'),
    "Queue"=c('fullName','doesSendEmailToMembers','email','name','queueMembers','queueRoutingConfig','queueSobject'),
    "QueueMembers"=c('publicGroups','roleAndSubordinates','roleAndSubordinatesInternal','roles','users'),
    "QueueSobject"=c('sobjectType'),
    "QuickAction"=c('fullName','canvas','description','fieldOverrides','flowDefinition','height','icon','isProtected','label','lightningComponent','optionsCreateFeedItem','page','quickActionLayout','quickActionSendEmailOptions','standardLabel','successMessage','targetObject','targetParentField','targetRecordType','type','width'),
    "QuickActionLayout"=c('layoutSectionStyle','quickActionLayoutColumns'),
    "QuickActionLayoutColumn"=c('quickActionLayoutItems'),
    "QuickActionLayoutItem"=c('emptySpace','field','uiBehavior'),
    "QuickActionList"=c('quickActionListItems'),
    "QuickActionListItem"=c('quickActionName'),
    "QuickActionSendEmailOptions"=c('defaultEmailTemplateName','ignoreDefaultEmailTemplateSubject'),
    "QuickActionTranslation"=c('label','name'),
    "QuotasSettings"=c('showQuotas'),
    "QuoteSettings"=c('fullName','enableQuote'),
    "RecommendationAudience"=c('recommendationAudienceDetails'),
    "RecommendationAudienceDetail"=c('audienceCriteriaType','audienceCriteriaValue','setupName'),
    "RecommendationDefinition"=c('recommendationDefinitionDetails'),
    "RecommendationDefinitionDetail"=c('actionUrl','description','linkText','scheduledRecommendations','setupName','title'),
    "RecommendationStrategy"=c('fullName','description','masterLabel','recommendationStrategyName','strategyNode'),
    "RecordType"=c('fullName','active','businessProcess','compactLayoutAssignment','description','label','picklistValues'),
    "RecordTypePicklistValue"=c('picklist','values'),
    "RecordTypeTranslation"=c('description','label','name'),
    "RelatedContent"=c('relatedContentItems'),
    "RelatedContentItem"=c('layoutItem'),
    "RelatedList"=c('hideOnDetail','name'),
    "RelatedListItem"=c('customButtons','excludeButtons','fields','relatedList','sortField','sortOrder'),
    "RemoteSiteSetting"=c('fullName','description','disableProtocolSecurity','isActive','url'),
    "Report"=c('fullName','aggregates','block','blockInfo','buckets','chart','colorRanges','columns','crossFilters','currency','dataCategoryFilters','description','division','filter','folderName','format','groupingsAcross','groupingsDown','historicalSelector','name','numSubscriptions','params','reportType','roleHierarchyFilter','rowLimit','scope','showCurrentDate','showDetails','sortColumn','sortOrder','territoryHierarchyFilter','timeFrameFilter','userFilter'),
    "ReportAggregate"=c('acrossGroupingContext','calculatedFormula','datatype','description','developerName','downGroupingContext','isActive','isCrossBlock','masterLabel','reportType','scale'),
    "ReportAggregateReference"=c('aggregate'),
    "ReportBlockInfo"=c('aggregateReferences','blockId','joinTable'),
    "ReportBucketField"=c('bucketType','developerName','masterLabel','nullTreatment','otherBucketLabel','sourceColumnName','useOther','values'),
    "ReportBucketFieldSourceValue"=c('from','sourceValue','to'),
    "ReportBucketFieldValue"=c('sourceValues','value'),
    "ReportChart"=c('backgroundColor1','backgroundColor2','backgroundFadeDir','chartSummaries','chartType','enableHoverLabels','expandOthers','groupingColumn','legendPosition','location','secondaryGroupingColumn','showAxisLabels','showPercentage','showTotal','showValues','size','summaryAxisManualRangeEnd','summaryAxisManualRangeStart','summaryAxisRange','textColor','textSize','title','titleColor','titleSize'),
    "ReportChartComponentLayoutItem"=c('cacheData','contextFilterableField','error','hideOnError','includeContext','reportName','showTitle','size'),
    "ReportColorRange"=c('aggregate','columnName','highBreakpoint','highColor','lowBreakpoint','lowColor','midColor'),
    "ReportColumn"=c('aggregateTypes','field','reverseColors','showChanges'),
    "ReportCrossFilter"=c('criteriaItems','operation','primaryTableColumn','relatedTable','relatedTableJoinColumn'),
    "ReportDataCategoryFilter"=c('dataCategory','dataCategoryGroup','operator'),
    "ReportFilter"=c('booleanFilter','criteriaItems','language'),
    "ReportFilterItem"=c('column','columnToColumn','isUnlocked','operator','snapshot','value'),
    "ReportFolder"=c('accessType','folderShares','name','publicFolderAccess','sharedTo'),
    "ReportGrouping"=c('aggregateType','dateGranularity','field','sortByName','sortOrder','sortType'),
    "ReportHistoricalSelector"=c('snapshot'),
    "ReportLayoutSection"=c('columns','masterLabel'),
    "ReportParam"=c('name','value'),
    "ReportTimeFrameFilter"=c('dateColumn','endDate','interval','startDate'),
    "ReportType"=c('fullName','autogenerated','baseObject','category','deployed','description','join','label','sections'),
    "ReportTypeColumn"=c('checkedByDefault','displayNameOverride','field','table'),
    "ReportTypeColumnTranslation"=c('label','name'),
    "ReportTypeSectionTranslation"=c('columns','label','name'),
    "ReportTypeTranslation"=c('description','label','name','sections'),
    "ReputationBranding"=c('smallImage'),
    "ReputationLevel"=c('branding','label','lowerThreshold'),
    "ReputationLevelDefinitions"=c('level'),
    "ReputationLevels"=c('chatterAnswersReputationLevels','ideaReputationLevels'),
    "ReputationPointsRule"=c('eventType','points'),
    "ReputationPointsRules"=c('pointsRule'),
    "RetrieveRequest"=c('apiVersion','packageNames','singlePackage','specificFiles','unpackaged'),
    "Role"=c('caseAccessLevel','contactAccessLevel','description','mayForecastManagerShare','name','opportunityAccessLevel','parentRole'),
    "RoleAndSubordinates"=c('roleAndSubordinate'),
    "RoleAndSubordinatesInternal"=c('roleAndSubordinateInternal'),
    "RoleOrTerritory"=c('fullName','caseAccessLevel','contactAccessLevel','description','mayForecastManagerShare','name','opportunityAccessLevel'),
    "Roles"=c('role'),
    "RuleEntry"=c('assignedTo','assignedToType','booleanFilter','businessHours','businessHoursSource','criteriaItems','disableEscalationWhenModified','escalationAction','escalationStartTime','formula','notifyCcRecipients','overrideExistingTeams','replyToEmail','senderEmail','senderName','team','template'),
    "SamlSsoConfig"=c('fullName','attributeName','attributeNameIdFormat','decryptionCertificate','errorUrl','executionUserId','identityLocation','identityMapping','issuer','loginUrl','logoutUrl','name','oauthTokenEndpoint','redirectBinding','requestSignatureMethod','requestSigningCertId','salesforceLoginUrl','samlEntityId','samlJitHandlerId','samlVersion','singleLogoutBinding','singleLogoutUrl','userProvisioning','validationCert'),
    "ScheduledRecommendation"=c('scheduledRecommendationDetails'),
    "ScheduledRecommendationDetail"=c('channel','enabled','rank','recommendationAudience'),
    "Scontrol"=c('content','contentSource','description','encodingKey','fileContent','fileName','name','supportsCaching'),
    "ScontrolTranslation"=c('label','name'),
    "SearchLayouts"=c('customTabListAdditionalFields','excludedStandardButtons','listViewButtons','lookupDialogsAdditionalFields','lookupFilterFields','lookupPhoneDialogsAdditionalFields','searchFilterFields','searchResultsAdditionalFields','searchResultsCustomButtons'),
    "SearchSettings"=c('fullName','documentContentSearchEnabled','optimizeSearchForCJKEnabled','recentlyViewedUsersForBlankLookupEnabled','searchSettingsByObject','sidebarAutoCompleteEnabled','sidebarDropDownListEnabled','sidebarLimitToItemsIOwnCheckboxEnabled','singleSearchResultShortcutEnabled','spellCorrectKnowledgeSearchEnabled'),
    "SearchSettingsByObject"=c('searchSettingsByObject'),
    "SecuritySettings"=c('fullName','networkAccess','passwordPolicies','sessionSettings'),
    "ServiceCloudConsoleConfig"=c('componentList','detailPageRefreshMethod','footerColor','headerColor','keyboardShortcuts','listPlacement','listRefreshMethod','liveAgentConfig','primaryTabColor','pushNotifications','tabLimitConfig','whitelistedDomains'),
    "SessionSettings"=c('disableTimeoutWarning','enableCSPOnEmail','enableCSRFOnGet','enableCSRFOnPost','enableCacheAndAutocomplete','enableClickjackNonsetupSFDC','enableClickjackNonsetupUser','enableClickjackNonsetupUserHeaderless','enableClickjackSetup','enableContentSniffingProtection','enablePostForSessions','enableSMSIdentity','enableUpgradeInsecureRequests','enableXssProtection','enforceIpRangesEveryRequest','forceLogoutOnSessionTimeout','forceRelogin','hstsOnForcecomSites','identityConfirmationOnEmailChange','identityConfirmationOnTwoFactorRegistrationEnabled','lockSessionsToDomain','lockSessionsToIp','logoutURL','redirectionWarning','referrerPolicy','requireHttpOnly','requireHttps','securityCentralKillSession','sessionTimeout'),
    "SFDCMobileSettings"=c('enableMobileLite','enableUserToDeviceLinking'),
    "SharedTo"=c('allCustomerPortalUsers','allInternalUsers','allPartnerUsers','channelProgramGroup','channelProgramGroups','group','groups','managerSubordinates','managers','portalRole','portalRoleAndSubordinates','queue','role','roleAndSubordinates','roleAndSubordinatesInternal','roles','rolesAndSubordinates','territories','territoriesAndSubordinates','territory','territoryAndSubordinates'),
    "SharingBaseRule"=c('fullName','accessLevel','accountSettings','description','label','sharedTo'),
    "SharingCriteriaRule"=c('accessLevel','accountSettings','description','label','sharedTo','booleanFilter','criteriaItems'),
    "SharingOwnerRule"=c('accessLevel','accountSettings','description','label','sharedTo','sharedFrom'),
    "SharingReason"=c('fullName','label'),
    "SharingReasonTranslation"=c('label','name'),
    "SharingRecalculation"=c('className'),
    "SharingRules"=c('fullName','sharingCriteriaRules','sharingOwnerRules','sharingTerritoryRules'),
    "SharingSet"=c('fullName','accessMappings','description','name','profiles'),
    "SharingTerritoryRule"=c('sharedFrom'),
    "SidebarComponent"=c('componentType','createAction','enableLinking','height','label','lookup','page','relatedLists','unit','updateAction','width'),
    "SiteDotCom"=c('content','label','siteType'),
    "SiteRedirectMapping"=c('action','isActive','source','target'),
    "SiteWebAddress"=c('certificate','domainName','primary'),
    "Skill"=c('fullName','assignments','description','label'),
    "SkillAssignments"=c('profiles','users'),
    "SkillProfileAssignments"=c('profile'),
    "SkillUserAssignments"=c('user'),
    "SocialCustomerServiceSettings"=c('fullName','caseSubjectOption'),
    "StandardFieldTranslation"=c('label','name'),
    "StandardValue"=c('color','default','description','isActive','label','allowEmail','closed','converted','cssExposed','forecastCategory','groupingString','highPriority','probability','reverseRole','reviewed','won'),
    "StandardValueSet"=c('fullName','groupingStringEnum','sorted','standardValue'),
    "StandardValueSetTranslation"=c('fullName','valueTranslation'),
    "State"=c('active','integrationValue','isoCode','label','standard','visible'),
    "StaticResource"=c('content','cacheControl','contentType','description'),
    "StrategyNode"=c('definition','description','name','parentNode','type'),
    "SubtabComponents"=c('containers'),
    "SummaryLayout"=c('masterLabel','sizeX','sizeY','sizeZ','summaryLayoutItems','summaryLayoutStyle'),
    "SummaryLayoutItem"=c('customLink','field','posX','posY','posZ'),
    "SupervisorAgentConfigSkills"=c('skill'),
    "SynonymDictionary"=c('fullName','groups','isProtected','label'),
    "SynonymGroup"=c('languages','terms'),
    "TabLimitConfig"=c('maxNumberOfPrimaryTabs','maxNumberOfSubTabs'),
    "Territory"=c('caseAccessLevel','contactAccessLevel','description','mayForecastManagerShare','name','opportunityAccessLevel','accountAccessLevel','parentTerritory'),
    "Territory2"=c('fullName','accountAccessLevel','caseAccessLevel','contactAccessLevel','customFields','description','name','opportunityAccessLevel','parentTerritory','ruleAssociations','territory2Type'),
    "Territory2Model"=c('fullName','customFields','description','name'),
    "Territory2Rule"=c('fullName','active','booleanFilter','name','objectType','ruleItems'),
    "Territory2RuleAssociation"=c('inherited','ruleName'),
    "Territory2RuleItem"=c('field','operation','value'),
    "Territory2Settings"=c('fullName','defaultAccountAccessLevel','defaultCaseAccessLevel','defaultContactAccessLevel','defaultOpportunityAccessLevel','opportunityFilterSettings'),
    "Territory2SettingsOpportunityFilter"=c('apexClassName','enableFilter','runOnCreate'),
    "Territory2Type"=c('fullName','description','name','priority'),
    "TopicsForObjects"=c('fullName','enableTopics','entityApiName'),
    "TouchMobileSettings"=c('enableTouchAppIPad','enableTouchAppIPhone','enableTouchBrowserIPad','enableTouchIosPhone','enableVisualforceInTouch'),
    "TransactionSecurityAction"=c('block','endSession','freezeUser','notifications','twoFactorAuthentication'),
    "TransactionSecurityNotification"=c('inApp','sendEmail','user'),
    "TransactionSecurityPolicy"=c('fullName','action','active','apexClass','description','developerName','eventName','eventType','executionUser','flow','masterLabel','resourceName','type'),
    "Translations"=c('fullName','customApplications','customDataTypeTranslations','customLabels','customPageWebLinks','customTabs','flowDefinitions','quickActions','reportTypes','scontrols'),
    "UiFormulaCriterion"=c('leftValue','operator','rightValue'),
    "UiFormulaRule"=c('booleanFilter','criteria'),
    "UiPlugin"=c('content','description','extensionPointIdentifier','isEnabled','language','masterLabel'),
    "UserCriteria"=c('fullName','creationAgeInSeconds','description','lastChatterActivityAgeInSeconds','masterLabel','profiles','userTypes'),
    "Users"=c('user'),
    "ValidationRule"=c('fullName','active','description','errorConditionFormula','errorDisplayField','errorMessage'),
    "ValidationRuleTranslation"=c('errorMessage','name'),
    "ValueSet"=c('controllingField','restricted','valueSetDefinition','valueSetName','valueSettings'),
    "ValueSettings"=c('controllingFieldValue','valueName'),
    "ValueSetValuesDefinition"=c('sorted','value'),
    "ValueTranslation"=c('masterLabel','translation'),
    "ValueTypeField"=c('fields','foreignKeyDomain','isForeignKey','isNameField','minOccurs','name','picklistValues','soapType','valueRequired'),
    "VisualizationPlugin"=c('fullName','description','developerName','icon','masterLabel','visualizationResources','visualizationTypes'),
    "VisualizationResource"=c('description','file','rank','type'),
    "VisualizationType"=c('description','developerName','icon','masterLabel','scriptBootstrapMethod'),
    "WaveApplication"=c('fullName','assetIcon','description','folder','masterLabel','shares','templateOrigin','templateVersion'),
    "WaveDashboard"=c('content','application','description','masterLabel','templateAssetSourceName'),
    "WaveDataflow"=c('content','dataflowType','description','masterLabel'),
    "WaveDataset"=c('fullName','application','description','masterLabel','templateAssetSourceName'),
    "WaveLens"=c('content','application','datasets','description','masterLabel','templateAssetSourceName','visualizationType'),
    "WaveRecipe"=c('content','dataflow','masterLabel','securityPredicate','targetDatasetAlias'),
    "WaveTemplateBundle"=c('fullName','assetIcon','assetVersion','description','label','templateBadgeIcon','templateDetailIcon','templateType'),
    "WaveXmd"=c('fullName','application','dataset','datasetConnector','datasetFullyQualifiedName','dates','dimensions','measures','organizations','origin','type','waveVisualization'),
    "WaveXmdDate"=c('alias','compact','dateFieldDay','dateFieldEpochDay','dateFieldEpochSecond','dateFieldFiscalMonth','dateFieldFiscalQuarter','dateFieldFiscalWeek','dateFieldFiscalYear','dateFieldFullYear','dateFieldHour','dateFieldMinute','dateFieldMonth','dateFieldQuarter','dateFieldSecond','dateFieldWeek','dateFieldYear','description','firstDayOfWeek','fiscalMonthOffset','isYearEndFiscalYear','label','showInExplorer','sortIndex'),
    "WaveXmdDimension"=c('customActions','customActionsEnabled','dateFormat','description','field','fullyQualifiedName','imageTemplate','isDerived','isMultiValue','label','linkTemplate','linkTemplateEnabled','linkTooltip','members','origin','recordDisplayFields','recordIdField','recordOrganizationIdField','salesforceActions','salesforceActionsEnabled','showDetailsDefaultFieldIndex','showInExplorer','sortIndex'),
    "WaveXmdDimensionCustomAction"=c('customActionName','enabled','icon','method','sortIndex','target','tooltip','url'),
    "WaveXmdDimensionMember"=c('color','label','member','sortIndex'),
    "WaveXmdDimensionSalesforceAction"=c('enabled','salesforceActionName','sortIndex'),
    "WaveXmdMeasure"=c('dateFormat','description','field','formatCustomFormat','formatDecimalDigits','formatIsNegativeParens','formatPrefix','formatSuffix','formatUnit','formatUnitMultiplier','fullyQualifiedName','isDerived','label','origin','showDetailsDefaultFieldIndex','showInExplorer','sortIndex'),
    "WaveXmdOrganization"=c('instanceUrl','label','organizationIdentifier','sortIndex'),
    "WaveXmdRecordDisplayLookup"=c('recordDisplayField'),
    "WebLink"=c('fullName','availability','description','displayType','encodingKey','hasMenubar','hasScrollbars','hasToolbar','height','isResizable','linkType','masterLabel','openType','page','position','protected','requireRowSelection','scontrol','showsLocation','showsStatus','url','width'),
    "WebLinkTranslation"=c('label','name'),
    "WebToCaseSettings"=c('caseOrigin','defaultResponseTemplate','enableWebToCase'),
    "WeightedSourceCategory"=c('sourceCategoryApiName','weight'),
    "Workflow"=c('fullName','alerts','fieldUpdates','flowActions','knowledgePublishes','outboundMessages','rules','send','tasks'),
    "WorkflowAction"=c('fullName'),
    "WorkflowActionReference"=c('name','type'),
    "WorkflowAlert"=c('ccEmails','description','protected','recipients','senderAddress','senderType','template'),
    "WorkflowEmailRecipient"=c('field','recipient','type'),
    "WorkflowFieldUpdate"=c('description','field','formula','literalValue','lookupValue','lookupValueType','name','notifyAssignee','operation','protected','reevaluateOnChange','targetObject'),
    "WorkflowFlowAction"=c('description','flow','flowInputs','label','language','protected'),
    "WorkflowFlowActionParameter"=c('name','value'),
    "WorkflowKnowledgePublish"=c('action','description','label','language','protected'),
    "WorkflowRule"=c('fullName','actions','active','booleanFilter','criteriaItems','description','formula','triggerType','workflowTimeTriggers'),
    "WorkflowSend"=c('action','description','label','language','protected'),
    "WorkflowTask"=c('assignedTo','assignedToType','description','dueDateOffset','notifyAssignee','offsetFromField','priority','protected','status','subject'),
    "WorkflowTaskTranslation"=c('description','name','subject'),
    "WorkflowTimeTrigger"=c('actions','offsetFromField','timeLength','workflowTimeTriggerUnit'),
    "WorkspaceMapping"=c('fieldName','tab')
  )

  return(reference_list)
}
