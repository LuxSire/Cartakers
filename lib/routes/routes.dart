// routes.dart

class Routes {
  static const login = '/login';
  static const forgotPassword = '/forgotPassword';

  static const resetPassword = '/resetPassword';
  static const dashboard = '/dashboard';
  static const media = '/media';
  static const plans = '/plans';

  static const banners = '/banners';
  static const createBanner = '/createBanner';
  static const editBanner = '/editBanner';

  static const products = '/products';
  static const createProduct = '/createProducts';
  static const editProduct = '/editProduct';

  static const categories = '/categories';
  static const createCategory = '/createCategory';
  static const editCategory = '/editCategory';

  static const brands = '/brands';
  static const createBrand = '/createBrand';
  static const editBrand = '/editBrand';

  static const customers = '/customers';
  static const createCustomer = '/createCustomer';
  static const customerDetails = '/customerDetails';

  static const units = '/units';
  static const unitDetails = '/unitDetails';

  static const coupons = '/coupons';
  static const createCoupon = '/createCoupon';
  static const editCoupon = '/editCoupon';

  static const settings = '/settings';
  static const profile = '/profile';

  static const objectsUnits = '/objectsUnits';
  static const usersPermissions = '/usersPermissions';
  static const permissionDetails = '/permissionDetails';
  static const userDetails = '/userDetails';

  static const maintenanceTasks = '/maintenanceTasks';
  static const amenitiesBookings = '/amenitiesBookings';
  static const bookingsRequests = '/bookingsRequests';
  static const tasks = '/tasks';
  static const communication = '/communication';
  static const settingsManagement = '/settingsManagement';
  static const objects = '/objects';
  static const editObject = '/editObject';

  static const invitation = '/invitation';
  static const registerAdmin = '/registerAdmin';
  static const splash = '/splash';

  static List sideMenuItems = [
    login,
    dashboard,
    media,
    products,
    categories,
    brands,
    customers,
    units,
    coupons,
    settings,
    profile,
    objectsUnits,
    usersPermissions,
    maintenanceTasks,
    amenitiesBookings,
    communication,
    settingsManagement,
    objects,
    invitation,
    registerAdmin,
    editObject,
    permissionDetails,
    userDetails,
    bookingsRequests,
    tasks,
    forgotPassword,
  ];
}

// All App Screens
class AppScreens {
  static const home = '/';
  static const store = '/store';
  static const favourites = '/favourites';
  static const settings = '/settings';
  static const subCategories = '/sub-categories';
  static const search = '/search';
  static const productReviews = '/product-reviews';
  static const productDetail = '/product-detail';
  static const order = '/order';
  static const checkout = '/checkout';
  static const cart = '/cart';
  static const brand = '/brand';
  static const allProducts = '/all-products';
  static const userProfile = '/user-profile';
  static const userAddress = '/user-address';
  static const signUp = '/signup';
  static const signupSuccess = '/signup-success';
  static const verifyEmail = '/verify-email';
  static const signIn = '/sign-in';
  static const resetPassword = '/reset-password';
  static const forgetPassword = '/forget-password';
  static const onBoarding = '/on-boarding';
  static const invitation = '/invitation';
  static const registerAdmin = '/register-admin';
  static const splash = '/splash';
  static const editObject = '/edit-object';
  static const unitDetails = '/unit-details';
  static const objectsUnits = '/objects-units';
  static const editObjectUnit = '/edit-object-unit';
  static const createObjectUnit = '/create-object-unit';
  static const createObject = '/create-object';
  static const forgotPassword = '/forgot-password';

  static List<String> allAppScreenItems = [
    onBoarding,
    signIn,
    signUp,
    verifyEmail,
    resetPassword,
    forgetPassword,
    home,
    store,
    favourites,
    settings,
    subCategories,
    search,
    productDetail,
    productReviews,
    order,
    checkout,
    cart,
    brand,
    allProducts,
    userProfile,
    userAddress,
    signUp,
    signupSuccess,
    editObject,
    unitDetails,
    objectsUnits,
    editObjectUnit,
    createObjectUnit,
    createObject,
    createObject,
    invitation,
    registerAdmin,
    splash,
    forgotPassword,
  ];
}
