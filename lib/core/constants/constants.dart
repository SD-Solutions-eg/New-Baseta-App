const baseUrlBasita =

    'https://basita.sdsolutionseg.com/wp-json';
    // 'https://business.basita.app/wp-json';

const appNameEn = 'Basita';

/// RegExp
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String _phonePattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
final RegExp phoneValidationRegExp = RegExp(_phonePattern);

//Admin Basic Auth
const adminBasicAuth =

    'cs_1c3824c16c7852eb023c78a36f9c14ee11d6a5b8';
    // 'Basic YXBpOkUkZGwoWlB0a2x2a1FwQjQ3MjJlcmklUQ==';

const contentTypeTxt = 'Content-Type';
const applicationJson = 'application/json';

const updateAcfEP = '/acf/v3/users/';

const userCredentialsTxt = 'userCredentials';

//FCM Token
const setTokenEP = '/firebase-notifications/v1/token';

//Chats
const chatsEP = '/wp/v2/chat';
const commentEP = '/wp/v2/comments';
const chatFields = 'id,date,title,_links';
const commentFields =
    'id,author,author_name,date,content,author_avatar_urls,meta';

//Company Reviews
const companyReviewsEP = '/wp/v2/pages/131';
const companyReviewsFields = 'id,date,title,_links';

//Captain reviews
const reviewsEP = '/wp/v2/reviews';
const deliveryReviewsFields = 'id,date,acf,content';

const usersEP = '/wp/v2/users/';
const userFields =
    'id,first_name,last_name,username,email,name,roles,avatar_urls,acf';
const bearerTxt = 'Bearer ';
const isNewUserTxt = 'isNewUser';
const renderedTxt = 'rendered';
const appLogo = 'assets/images/logo.png';
const userId = 'userId';
const authProviderTxt = 'authProvider';
const googleTxt = 'Google';
const facebookTxt = 'Facebook';
const wooCommerceTxt = 'WooCommerce';
const authorizationTxt = 'Authorization';

const keyTxt = 'consumer_key';
const secretTxt = 'consumer_secret';

const fieldsTxt = '_fields';
const orderByTxt = 'orderby';
const orderTxt = 'order';
const perPageTxt = 'per_page';
const pageTxt = 'page';

//Products
const packagesEP = '/wp/v2/package';
String productVariationsEP(int id) {
  return '$packagesEP$id/variations';
}

const productRequiredFields =
    'id,name,slug,permalink,date_created,date_modified,type,status,featured,catalog_visibility,description,short_description,sku,price,regular_price,sale_price,on_sale,reviews_allowed,average_rating, rating_count,categories,images,stock_status,total_sales,related_ids,attributes,variations,acf';

//Slideshow custom fields
const slideshowEP = '/wp/v2/slideshow';
const slideshowFields = 'id,title,content,acf,_links';
const embedTxt = '_embed';
const featuredMediaEmbedded = 'wp:featuredmedia';

//About
const aboutEP = '/acf/v3/options/options/about';
const aboutImageEP = '/acf/v3/options/options/about_image';

//ContactUS
const contactUsEP = '/acf/v3/options/options/';
const contactFormEP = '/contact-form-7/v1/contact-forms/243/feedback';
const contactFormEPLive = '/contact-form-7/v1/contact-forms/5/feedback';

//Notifications
const notificationsEP = '/firebase-notifications/v1/notifications';

//Orders
const paymentEP = '/wp/v2/payment_method/';
const paymentFields = 'id,title,description,enabled';
const thankYouPageEP = '/acf/v3/options/options/order_thank_you';
const ordersEP = '/wp/v2/orders';
const orderFields =
    'id,acf,date,author,modified,content,_links,discount,coupon,delivery_mobile';

//Cart
const cartEP = '/wc/store/cart/';
const cartItemsEP = '/wc/store/cart/items/';
const addItemToCartEP = '/wc/store/cart/add-item';
const removeFromCartEP = '/wc/store/cart/remove-item/';
const updateCartItemEP = '/wc/store/cart/update-item/';
const applyCouponEP = '/wc/store/cart/apply-coupon/';
const removeCouponEP = '/wc/store/cart/remove-coupon';

const wishlistEp = '/wc/v3/wishlist/';

//blogs
const blogsEP = '/wp/v2/posts';
const blogsFields = 'id,title,content,_links';

const categoriesEP = '/wc/v3/products/categories/';

//FAQs
const faqsEp = '/wp/v2/faq/';
const faqCategoriesEP = '/wp/v2/faq_cat/';

//Login & Registration & Customer
const customerEP = '/wc/v3/customers/';
const registerEP = '/wc/v3/customers/';
const loginEP = '/wp/v2/users/me/';
const resetPasswordEP = '/bdpwr/v1/reset-password';
const validateAndSetPasswordEP = '/bdpwr/v1/set-password';
const registerRequiredFields = 'id,username,avatar_url';
const loginRequiredFields = 'id,name,avatar_urls';

//Outer links
const privacyEP = '/acf/v3/options/options/policy_app';
const termsEP = '/acf/v3/options/options/terms';
const returnEP = '/acf/v3/options/options/return_policy';
const shippingEP = '/acf/v3/options/options/shipping_policy';

const privacyImageEP = '/acf/v3/options/options/policy_image';
const termsImageEP = '/acf/v3/options/options/terms_image';
const returnImageEP = '/acf/v3/options/options/return_policy_image';
const shippingImageEP = '/acf/v3/options/options/shipping_policy_image';

const attributesEP = '/wc/v3/products/attributes/';

String attributeTermsEP(int id) => '$attributesEP$id/terms';

const settingsEP = '/acf/v3/options/options';

//Sections
const sectionsEP = '/wp/v2/section';
const sectionsFields = 'id,title,content,_links';

//Cites
const citiesEp = '/wp/v2/city';
const citiesFields = 'id,name,count';

//Areas
const areasEp = '/wp/v2/area';
const areasFields = 'id,title,city,acf';

//User Data
const userDataEP = '/wp/v2/user_data/';
const userDataFields = 'id,title,author,acf';

//Partners
const partnersEP = '/wp/v2/partner';
const partnersFields = 'id, title,content,_links,acf';
const featureTxt = 'feature';

//PayTabs
const payTabsEP = '/acf/v3/options/options/paytabs_account';
