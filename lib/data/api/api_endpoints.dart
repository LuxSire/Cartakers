class ApiEndpoints {
  static const String customToken = 'api/firebase/custom-token';
  static const String sendPushNotification =
      'api/firebase/send-push-notification';
  static const String userProfile = 'api/user/profile';
  static const String properties = 'api/properties';
  static const String validateUserInvitationToken =
      'api/users/validate-user-invitation-token';
  static const String registerUser = 'api/users/register-user';
  static const String loginUser = 'api/users/login-user';
  static const String getUserByEmail = 'api/users/get-user-by-email';
  static const String getUserById = 'api/users/get-user-by-id';
  static const String getUsersByCompany = 'api/users/get-users-by-company';
  static const String getAllObjects = 'api/objects/get-all-objects';
  static const String getAllUsers = 'api/users/get-all-users';
  static const String getAllCompanies = 'api/users/get-all-companies';
  static const String getAllPermissions = 'api/objects/get-all-permissions';
  static const String getAllZonings = 'api/objects/get-all-zonings';
  static const String getAllOccupancies = 'api/objects/get-all-occupancies';
  static const String removePermission = 'api/objects/remove-permission';
  static const String createPermission = 'api/objects/create-permission';
  static const String getAllBookingCategories = 'api/objects/get-all-booking-categories';

  static const String getAllTypes = 'api/objects/get-all-types';
  static const String getObjectsLastAnnouncement =
      'api/objects/get-object-last-announcement';
  static const String getObjectDocUrls =
      'api/objects/get-object-doc-urls';
   static const String getObjectDocs =
      'api/objects/get-object-docs';
   static const String getUserDocs =
      'api/objects/get-user-docs';

  static const String getUserUpcomingBooking =
      'api/users/get-user-upcoming-booking';
  static const String getObjectRequestTypes =
      'api/objects/get-object-request-types';
  static const String createUserObjectRequest =
      'api/users/create-user-object-request';
  static const String createUserObjectRequestLog =
      'api/users/create-user-object-request-log';
  static const String uploadUserMedia = 'api/users/upload-user-media';
  static const String deleteUserMedia = 'api/users/delete-user-media';

  static const String createUserObjectRequestMedia =
      'api/users/create-user-object-request-media';
  static const String getUserObjectRequests =
      'api/users/get-user-object-requests';
  static const String getObjectRequestLogs =
      'api/objects/get-object-request-logs';
  static const String updateUserObjectRequestStatus =
      'api/users/update-user-object-request-status';
  static const String getObjectContactNumbers =
      'api/buildings/get-object-contact-numbers';
  static const String createUserObjectPost =
      'api/users/create-user-object-post';
  static const String createUserObjectPostMedia =
      'api/users/create-user-object-post-media';
  static const String getObjectPosts = 'api/objects/get-object-posts';
  static const String createUserObjectPostComment =
      'api/users/create-user-object-post-comment';
  static const String createUserObjectPostLike =
      'api/users/create-user-object-post-like';
  static const String deleteUserObjectPostLike =
      'api/users/delete-user-object-post-like';
  static const String updateUserPersonalDetails =
      'api/users/update-user-personal-details';

  static const String getUserUpcomingBookings =
      'api/users/get-user-upcoming-bookings';
  static const String getUserPastBookings =
      'api/users/get-user-past-bookings';

  static const String getObjectBookingTypes =
      'api/objects/get-object-booking-types';
  static const String getUserObjectBookingTypes =
      'api/users/get-user-object-booking-types';
  static const String getUserAvailableBuildingAmenityUnits =
      'api/users/get-user-object-available-amenity-units';
  static const String getObjectAmenityUnitTimeslots =
      'api/objects/get-object-amenity-unit-timeslots';
  static const String createUserObjectBooking =
      'api/users/create-user-object-booking';
  static const String updateUserObjectBooking =
      'api/users/update-user-object-booking';
  static const String updateUserObjectBookingStatus =
      'api/users/update-user-object-booking-status';
  static const String getUserAllBookings =
      'api/users/get-user-all-bookings';
  static const String getUserAllRequests =
      'api/users/get-user-all-requests';
  static const String getUserObjectDocs =
      'api/users/get-user-object-docs';
  static const String getUserObjectHelpGuides =
      'api/users/get-user-object-help-guides';
  static const String sendUserPasswordResetEmail =
      'api/mailing/email-user-reset-password';

  static const String updateUserResetPasswordCode =
      'api/users/update-user-reset-password-code';
  static const String updateUserDeviceToken =
      'api/users/update-user-device-token';

  static const String updateTokenByUser =
      'api/users/update-token-by-user';

  static const String getUserByResetCode =
      'api/users/get-user-by-reset-code';
  static const String updateUserPassword = 'api/users/update-user-password';
  static const String getUserNotifications =
      'api/users/get-user-notifications';
  static const String getUserObjectRequestById =
      'api/users/get-user-object-request-by-id';
  static const String updateUserNotificationStatus =
      'api/users/update-user-notification-status';
  static const String getUserObjectBookingById =
      'api/users/get-user-object-booking-by-id';
  static const String getUserObjectAnnouncements =
      'api/users/get-user-object-announcements';
  static const String getUserObjectAnnouncementById =
      'api/users/get-user-object-announcement-by-id';
  static const String getObjectById = 'api/objects/get-object-by-id';
  static const String deleteUserDeviceToken =
      'api/users/delete-user-device-token';
  static const String updateUserBookingReminders =
      'api/users/update-user-booking-reminders';
  static const String getUserDeviceTokens =
      'api/users/get-user-device-tokens';
  static const String updateUserLanguageCode =
      'api/users/update-user-language-code';
  static const String createUserObjectPostReport =
      'api/users/create-user-object-post-report';

  static const String deleteUserObjectPost =
      'api/users/delete-user-object-post';
  static const String deleteUserObjectPostComment =
      'api/users/delete-user-object-post-comment';

  ///////////// Agency Endpoints //////////////
  static const String validateCompanyInvitationToken =
      'api/users/validate-company-invitation-token';
  static const String registerupdateCompany = 'api/users/register-update-company';
  static const String getCompanyByEmail = 'api/users/get-company-by-email';
  static const String getCompanyById = 'api/users/get-company-by-id';
  static const String getObjectsByCompanyId =
      'api/objects/get-objects-by-company-id';
  static const String updateObjectDetails =
      'api/objects/update-object-details';
  static const String getObjectUnitsById =
      'api/objects/get-object-units-by-id';
  static const String getAllUsersByContract =
      'api/users/get-all-users-by-contract';
  static const String getObjectUnitContractsByUnitId =
      'api/objects/get-object-unit-contracts-by-unit-id';
  static const String getObjectNonContractUsersByObjectId =
      'api/objects/get-object-non-contract-users-by-object-id';
  static const String getPermissionById = 'api/objects/get-permission-by-id';
  static const String updatePermissionDetails =
      'api/objects/update-permission-details';
  static const String createQuickNewUser =
      'api/users/create-quick-new-user';
  static const String createQuickNewCompany =
      'api/users/create-quick-new-company';
  static const String addUserToContract =
      'api/objects/add-user-to-contract';
  static const String deleteUsersFromContract =
      'api/objects/delete-users-from-contract';
  static const String getActiveContractByUnitId =
      'api/objects/get-active-contract-by-unit-id';
  static const String updateUnitstatus = 'api/objects/update-unit-status';
  static const String createContract = 'api/objects/create-contract';
  static const String getObjectZonesById =
      'api/objects/get-object-zones-by-id';

  static const String getObjectZoneAssigmentById =
      'api/objects/get-object-zone-assigment-by-id';
  static const String assignUnitsToZone = 'api/objects/assign-units-to-zone';

  static const String assignUnitsBatch = 'api/objects/assign-units-batch';
  static const String createAmenityZone = 'api/objects/create-amenity-zone';
  static const String removeUserFromObject =
      'api/objects/remove-user-from-object';

  static const String updateUserContractPrimary =
      'api/users/update-user-contract-primary';
  static const String createObjectMedia =
      'api/objects/create-object-media';
  static const String updateObject =
      'api/objects/update-object';
//  static const String deleteUserMedia = 'api/users/delete-profile-file';

  static const String deleteDocumentById =
      'api/objects/delete-document-by-id';

  static const String updateFileName = 'api/objects/update-file-name';
  static const String updateUserRequestStatus =
      'api/users/update-user-request-status';
  static const String createUserContractNotificationAndSendPush =
      'api/users/create-user-contract-notification-and-send-push';

  static const String getUserAllBookingsByUserId =
      'api/users/get-user-all-bookings-by-user-id';
  static const String getUserAllRequestsByUserId =
      'api/users/get-user-all-requests-by-user-id';

  static const String updateQuickUser = 'api/users/update-quick-user';
  static const String getAllUsersByObject =
      'api/users/get-all-users-by-object';

  static const String deleteUserObjectUser =
      'api/users/delete-user-object-user';

  static const String getAllObjectPermissions =
      'api/objects/get-all-object-permissions';
  static const String getAllUserPermissions =
      'api/users/get-all-user-permissions';

  static const String deleteContractById =
      'api/objects/delete-contract-by-id';

  static const String getObjectRecentBookings =
      'api/objects/get-object-recent-bookings';

  static const String getObjectAllRequests =
      'api/objects/get-object-all-requests';

  static const String getObjectAllUnits =
      'api/objects/get-object-all-units';

  static const String createObject = 'api/objects/create-object';
  static const String getAllUsersByCompany =
      'api/users/get-all-users-by-company';

  static const String getCompanyObjectsAllRequests =
      'api/objects/get-company-objects-all-requests';

  static const String getCompanyObjectsUnitsById =
      'api/objects/get-company-objects-units-by-id';

  static const String getAllCompanyObjectsContracts =
      'api/objects/get-all-company-objects-contracts';

  static const String getCompanyObjectsAllBookings =
      'api/objects/get-company-objects-all-bookings';

  static const String getAllCompanyMessages =
      'api/companies/get-all-company-messages';

  static const String createCompanyMessage =
      'api/companies/create-company-message';
  static const String deleteCompanyMessage =
      'api/companies/delete-company-message';
  static const String deleteCompanyById =
      'api/companies/delete-company-by-id';
  static const String getObjectUnitRoomList =
      'api/objects/get-object-unit-room-list';
  static const String updateObjectUnitRoom =
      'api/objects/update-object-unit-room';

  static const String getAllCompanyAmenityCategories =
      'api/companies/get-all-company-amenity-categories';

  static const String getUserAvailableObjectAmenityUnitsV2 =
      'api/users/get-user-object-available-amenity-units-v2';

  static const String getMaintenanceServicers =
      'api/agencies/get-maintenance-servicers';

  static const String getAllUsersByAgency = 'api/users/get-all-users-by-agency';
  static const String getUserRolesByRoleId =
      'api/users/get-user-roles-by-role-id';
  static const String getAllUserRoles =
      'api/users/get-all-user-roles';
  static const String createNewUser = 'api/users/create-quick-new-user';

  static const String assignUserToObjectsBatch =
      'api/users/assign-user-to-object-batch';
  static const String getUserAssignedObjects =
      'api/objects/get-objects-by-user-id';

  static const String deleteAllUserAssignedObjects =
      'api/objects/delete-all-user-assigned-objects';

  static const String deleteUserById = 'api/users/delete-user-by-id';
  static const String deleteUserDirectory = 'api/users/delete-user-directory';
  static const String createUserInvitationCode =
      'api/users/get-user-invitation-code';
  static const String sendUserInvitationEmail =
      'api/mailing/send-user-invitation-email';
  static const String updateUserInvitationStatus =
      'api/users/update-user-invitation-status';
  static const String updateUserStatus = 'api/users/update-user-status';
  static const String updateUserObjectStatus =
      'api/users/update-user-object-status';
  static const String assignUserToObjectPermission =
      'api/users/assign-user-to-object-permission';

  static const String deleteObjectById =
      'api/objects/delete-object-by-id';
  static const String updateQuickCompany =
      'api/users/update-quick-company';
}
