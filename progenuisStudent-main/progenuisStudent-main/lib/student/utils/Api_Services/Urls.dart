class ApiUrls{

  // static const baseUrls = "https://api.progeniusstudents.com/v1";
  static const baseUrls = "https://progenius-backend-production.up.railway.app/v1";
  static const file = "${baseUrls}/file";


  // STUDENT 
  static const Slogin = "${baseUrls}/customer/signin";
  static const Sregiter = "${baseUrls}/customer/signup";
  static const SgetProfile = "${baseUrls}/customer";



  // PAID COURSE
  static const paidCourse = "${baseUrls}/course/paid";

  // FREE COURSE
  static const freeCourse = "${baseUrls}/course/free";

  // GET CHAPTER
  static const getChapter = "${baseUrls}/chapter";

  // GET COURSE CHAPTER
   static const getCourseChapter = "${baseUrls}/course";
  

    // GET CHAPTER LESSON
  static const getAllChapterLesson = "${baseUrls}/chapter";
// lesson details
   static const getLessonDetails = "${baseUrls}/lesson";

  static const AallUser = "${baseUrls}/admin/customers";
//  FORGOT PASSWORD
  static const sendOTP = "${baseUrls}/auth/send-otp";
  static const verifyOTP = "${baseUrls}/auth/verify-otp";
  static const resetPassword = "${baseUrls}/auth/update-password";

// DASHBOARD
static const dashboard = "${baseUrls}/dashboard";

// STUDENT COURSE
static const studetnPaidCourse = "${baseUrls}/customer/paid-courses";


   

}