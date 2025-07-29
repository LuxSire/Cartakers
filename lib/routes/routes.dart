// routes.dart

class Routes {
  static const login = '/login';
  static const forgotPassword = '/forgotPassword';

  static const resetPassword = '/resetPassword';
  static const dashboard = '/dashboard';
  static const media = '/media';

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

  static const buildingsUnits = '/buildingsUnits';
  static const tenantsContracts = '/tenantsContracts';
  static const contractDetails = '/contractDetails';
  static const tenantDetails = '/tenantDetails';

  static const maintenanceTasks = '/maintenanceTasks';
  static const amenitiesBookings = '/amenitiesBookings';
  static const bookingsRequests = '/bookingsRequests';
  static const tasks = '/tasks';
  static const communication = '/communication';
  static const settingsManagement = '/settingsManagement';
  static const buildings = '/buildings';
  static const editBuilding = '/editBuilding';

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
    buildingsUnits,
    tenantsContracts,
    maintenanceTasks,
    amenitiesBookings,
    communication,
    settingsManagement,
    buildings,
    invitation,
    registerAdmin,
    editBuilding,
    contractDetails,
    tenantDetails,
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
  static const editBuilding = '/edit-building';
  static const unitDetails = '/unit-details';
  static const buildingsUnits = '/buildings-units';
  static const editBuildingUnit = '/edit-building-unit';
  static const createBuildingUnit = '/create-building-unit';
  static const createBuilding = '/create-building';
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
    editBuilding,
    unitDetails,
    buildingsUnits,
    editBuildingUnit,
    createBuildingUnit,
    createBuilding,
    createBuilding,
    invitation,
    registerAdmin,
    splash,
    forgotPassword,
  ];
}
