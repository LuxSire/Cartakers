class ApiEndpoints {
  static const String customToken = 'api/firebase/custom-token';
  static const String sendPushNotification =
      'api/firebase/send-push-notification';
  static const String userProfile = 'api/user/profile';
  static const String properties = 'api/properties';
  static const String validateTenantInvitationToken =
      'api/users/validate-tenant-invitation-token';
  static const String registerTenant = 'api/users/register-tenant';
  static const String loginTenant = 'api/users/login-tenant';
  static const String getTenantByEmail = 'api/users/get-tenant-by-email';
  static const String getTenantById = 'api/users/get-tenant-by-id';

  static const String getBuildingsLastAnnouncement =
      'api/buildings/get-building-last-announcement';
  static const String getTenantUpcomingBooking =
      'api/users/get-tenant-upcoming-booking';
  static const String getBuildingRequestTypes =
      'api/buildings/get-building-request-types';
  static const String createTenantBuildingRequest =
      'api/users/create-tenant-building-request';
  static const String createTenantBuildingRequestLog =
      'api/users/create-tenant-building-request-log';
  static const String uploadUserMedia = 'api/users/upload-user-media';
  static const String createTenantBuildingRequestMedia =
      'api/users/create-tenant-building-request-media';
  static const String getTenantBuildingRequests =
      'api/users/get-tenant-building-requests';
  static const String getBuildingRequestLogs =
      'api/buildings/get-building-request-logs';
  static const String updateTenantBuildingRequeststatus =
      'api/users/update-tenant-building-request-status';
  static const String getBuildingContactNumbers =
      'api/buildings/get-building-contact-numbers';
  static const String createTenantBuildingPost =
      'api/users/create-tenant-building-post';
  static const String createTenantBuildingPostMedia =
      'api/users/create-tenant-building-post-media';
  static const String getBuildingPosts = 'api/buildings/get-building-posts';
  static const String createTenantBuildingPostComment =
      'api/users/create-tenant-building-post-comment';
  static const String createTenantBuildingPostLike =
      'api/users/create-tenant-building-post-like';
  static const String deleteTenantBuildingPostLike =
      'api/users/delete-tenant-building-post-like';
  static const String updateTenantPersonalDetails =
      'api/users/update-tenant-personal-details';

  static const String getTenantUpcomingBookings =
      'api/users/get-tenant-upcoming-bookings';
  static const String getTenantPastBookings =
      'api/users/get-tenant-past-bookings';

  static const String getBuildingBookingTypes =
      'api/buildings/get-building-booking-types';
  static const String getTenantBuildingBookingTypes =
      'api/users/get-tenant-building-booking-types';
  static const String getTenantAvailableBuildingAmenityUnits =
      'api/users/get-tenant-building-available-amenity-units';
  static const String getBuildingAmenityUnitTimeslots =
      'api/buildings/get-building-amenity-unit-timeslots';
  static const String createTenantBuildingBooking =
      'api/users/create-tenant-building-booking';
  static const String updateTenantBuildingBooking =
      'api/users/update-tenant-building-booking';
  static const String updateTenantBuildingBookingStatus =
      'api/users/update-tenant-building-booking-status';
  static const String getTenantAllBookings =
      'api/users/get-tenant-all-bookings';
  static const String getTenantAllRequests =
      'api/users/get-tenant-all-requests';
  static const String getTenantBuildingDocs =
      'api/users/get-tenant-building-docs';
  static const String getTenantBuildingHelpGuides =
      'api/users/get-tenant-building-help-guides';
  static const String sendTenantPasswordResetEmail =
      'api/mailing/email-tenant-reset-password';

  static const String updateTenantResetPasswordCode =
      'api/users/update-tenant-reset-password-code';
  static const String updateTenantDeviceToken =
      'api/users/update-tenant-device-token';
  static const String getTenantByResetCode =
      'api/users/get-tenant-by-reset-code';
  static const String updateTenantPassword = 'api/users/update-tenant-password';
  static const String getTenantNotifications =
      'api/users/get-tenant-notifications';
  static const String getTenantBuildingRequestById =
      'api/users/get-tenant-building-request-by-id';
  static const String updateTenantNotificationStatus =
      'api/users/update-tenant-notification-status';
  static const String getTenantBuildingBookingById =
      'api/users/get-tenant-building-booking-by-id';
  static const String getTenantBuildingAnnoucemnts =
      'api/users/get-tenant-building-announcemnts';
  static const String getTenantBuildingAnnouncementById =
      'api/users/get-tenant-building-announcement-by-id';
  static const String getBuildingById = 'api/buildings/get-building-by-id';
  static const String deleteTenantDeviceToken =
      'api/users/delete-tenant-device-token';
  static const String updateTenantBookingReminders =
      'api/users/update-tenant-booking-reminders';
  static const String getTenantDeviceTokens =
      'api/users/get-tenant-device-tokens';
  static const String updateTenantLanguageCode =
      'api/users/update-tenant-language-code';
  static const String createTenantBuildingPostReport =
      'api/users/create-tenant-building-post-report';

  static const String deleteTenantBuildingPost =
      'api/users/delete-tenant-building-post';
  static const String deleteTenantBuildingPostComment =
      'api/users/delete-tenant-building-post-comment';

  ///////////// Agency Endpoints //////////////
  static const String validateAgentInvitationToken =
      'api/users/validate-agent-invitation-token';
  static const String registerAgent = 'api/users/register-agent';
  static const String getAgentByEmail = 'api/users/get-agent-by-email';
  static const String getAgentById = 'api/users/get-agent-by-id';
  static const String getBuildingsByAgencyId =
      'api/buildings/get-buildings-by-agency-id';
  static const String updateBuildingDetails =
      'api/buildings/update-building-details';
  static const String getBuildingUnitsById =
      'api/buildings/get-building-units-by-id';
  static const String getAllTenantsByContract =
      'api/users/get-all-tenants-by-contract';
  static const String getBuildingUnitContractsByUnitId =
      'api/buildings/get-building-unit-contracts-by-unit-id';
  static const String getBuildingNonContractTenantsByBuildingId =
      'api/buildings/get-building-non-contract-tenants-by-building-id';
  static const String getContractById = 'api/buildings/get-contract-by-id';
  static const String updateContractDetails =
      'api/buildings/update-contract-details';
  static const String createQuickNewTenant =
      'api/users/create-quick-new-tenant';
  static const String addTenantToContract =
      'api/buildings/add-tenant-to-contract';
  static const String deleteTenantsFromContract =
      'api/buildings/delete-tenants-from-contract';
  static const String getActiveContractByUnitId =
      'api/buildings/get-active-contract-by-unit-id';
  static const String updateUnitstatus = 'api/buildings/update-unit-status';
  static const String createContract = 'api/buildings/create-contract';
  static const String getBuildingZonesById =
      'api/buildings/get-building-zones-by-id';

  static const String getBuildingZoneAssigmentById =
      'api/buildings/get-building-zone-assigment-by-id';
  static const String assignUnitsToZone = 'api/buildings/assign-units-to-zone';

  static const String assignUnitsBatch = 'api/buildings/assign-units-batch';
  static const String createAmenityZone = 'api/buildings/create-amenity-zone';
  static const String removeTenantFromContract =
      'api/buildings/remove-tenant-from-contract';

  static const String updateTenantContractPrimary =
      'api/users/update-tenant-contract-primary';
  static const String createContractMedia =
      'api/buildings/create-contract-media';
  static const String deleteUserMedia = 'api/users/delete-profile-file';

  static const String deleteDocumentById =
      'api/buildings/delete-document-by-id';

  static const String updateFileName = 'api/buildings/update-file-name';
  static const String updateTenantRequestStatus =
      'api/users/update-tenant-request-status';
  static const String createTenantContractNotificationAndSendPush =
      'api/users/create-tenant-contract-notification-and-send-push';

  static const String getTenantAllBookingsByTenantId =
      'api/users/get-tenant-all-bookings-by-tenant-id';
  static const String getTenantAllRequestsByTenantId =
      'api/users/get-tenant-all-requests-by-tenant-id';

  static const String updateQuickTenant = 'api/users/update-quick-tenant';
  static const String getAllTenantsByBuilding =
      'api/users/get-all-tenants-by-building';

  static const String deleteTenantBuildingTenant =
      'api/users/delete-tenant-building-tenant';

  static const String getAllBuildingContracts =
      'api/buildings/get-all-building-contracts';

  static const String deleteContractById =
      'api/buildings/delete-contract-by-id';

  static const String getBuildingRecentBookings =
      'api/buildings/get-building-recent-bookings';

  static const String getBuildingAllRequests =
      'api/buildings/get-building-all-requests';

  static const String getBuildingAllUnits =
      'api/buildings/get-building-all-units';

  static const String createBuilding = 'api/buildings/create-building';
  static const String getAllTenantsByAgency =
      'api/users/get-all-tenants-by-agency';

  static const String getAgencyBuildingsAllRequests =
      'api/buildings/get-agency-buildings-all-requests';

  static const String getAgencyBuildingsUnitsById =
      'api/buildings/get-agency-buildings-units-by-id';

  static const String getAllAgencyBuildingsContracts =
      'api/buildings/get-all-agency-buildings-contracts';

  static const String getAgencyBuildingsAllBookings =
      'api/buildings/get-agency-buildings-all-bookings';

  static const String getAllAgencyMessages =
      'api/agencies/get-all-agency-messages';

  static const String createAgencyMessage =
      'api/agencies/create-agency-message';
  static const String deleteAgencyMessage =
      'api/agencies/delete-agency-message';

  static const String getBuildingUnitRoomList =
      'api/buildings/get-building-unit-room-list';
  static const String updateBuildingUnitRoom =
      'api/buildings/update-building-unit-room';

  static const String getAllAgencyAmenityCategories =
      'api/agencies/get-all-agency-amenity-categories';

  static const String getTenantAvailableBuildingAmenityUnitsV2 =
      'api/users/get-tenant-building-available-amenity-units-v2';

  static const String getMaintenanceServicers =
      'api/agencies/get-maintenance-servicers';
  static const String updateUserPersonalDetails =
      'api/users/update-user-personal-details';

  static const String getAllUsersByAgency = 'api/users/get-all-users-by-agency';
  static const String getUserRolesByRoleId =
      'api/users/get-user-roles-by-role-id';

  static const String createNewUser = 'api/users/create-new-user';

  static const String assignUserToBuildingsBatch =
      'api/users/assign-user-to-buildings-batch';
  static const String getUserAssignedBuildings =
      'api/users/get-user-assigned-buildings';

  static const String deleteAllUserAssignedBuildings =
      'api/users/delete-all-user-assigned-buildings';

  static const String deleteUserById = 'api/users/delete-user-by-id';
  static const String deleteUserDirectory = 'api/users/delete-user-directory';
  static const String createUserInvitationCode =
      'api/users/create-user-invitation-code';
  static const String createTenantInvitationCode =
      'api/users/create-tenant-invitation-code';
  static const String sendUserInvitationEmail =
      'api/mailing/send-user-invitation-email';
  static const String sendTenantInvitationEmail =
      'api/mailing/send-tenant-invitation-email';
  static const String updateUserInvitationStatus =
      'api/users/update-user-invitation-status';
  static const String updateUserStatus = 'api/users/update-user-status';
  static const String updateTenantBuildingStatus =
      'api/users/update-tenant-building-status';
  static const String assignUserToBuildingPermission =
      'api/users/assign-user-to-building-permission';

  static const String deleteBuildingById =
      'api/buildings/delete-building-by-id';

  static const String updateUserResetPasswordCode =
      'api/users/update-user-reset-password-code';

  static const String sendUserPasswordResetEmail =
      'api/mailing/email-user-reset-password';
  static const String getUserByResetCode = 'api/users/get-user-by-reset-code';
  static const String updateUserPassword = 'api/users/update-user-password';
}
