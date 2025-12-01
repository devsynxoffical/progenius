class ApiUrls{

  // static const baseUrls = "https://api.progeniusstudents.com/v1";
  static const baseUrls = "http://10.0.2.2:8000/v1"; // Use 10.0.2.2 for Android Emulator, localhost for iOS/Web
  static const file = "${baseUrls}/file/";

  // LOGIN  
  static const Alogin = "${baseUrls}/admin/signin"; 

  // SIGNUP
  static const Aregiter = "${baseUrls}/admin/signup";

 // GET PROFILE
  static const AgetProfile = "${baseUrls}/admin";

  // UPDATE PROFILE
  static const AupdateProfile = "${baseUrls}/admin";

  // ALL USER
  static const AallUser = "${baseUrls}/admin/customers";

  // DELETE USER
  static const AdeleteUser = "${baseUrls}/admin/customer";

  // PAID COURSE
  static const paidCourse = "${baseUrls}/course/paid";

  // FREE COURSE
  static const freeCourse = "${baseUrls}/course/free";

  // ADD COURSE
  static const addCourse = "${baseUrls}/course";

  // GET CHAPTER
  static const getChapter = "${baseUrls}/chapter";

  // GET COURSE CHAPTER
   static const getCourseChapter = "${baseUrls}/course";
  
  // LOCK AND UNLOCK 
  static const getChapterLock_Unlock = "${baseUrls}/chapter/lock-unlock";

   // ADD LESSON
  static const addLesson = "${baseUrls}/lesson";

    // GET CHAPTER LESSON
  static const getAllChapterLesson = "${baseUrls}/chapter";
// lesson details
   static const getLessonDetails = "${baseUrls}/lesson";


   // ALLOW & DIS_ALLOW STUDENT
 static const allowDisAllow = "${baseUrls}/admin/customer/update-access";


 // delete course
   static const deleteCourse = "${baseUrls}/course";

// update pdf
 static const updatePDF = "${baseUrls}/lesson/pdf";

// delete pdf
 static const deletePDF = "${baseUrls}/lesson/removePdf";

// student list
 static const studentList = "${baseUrls}/course/update-course-customer";

// DASHBOARD
static const dashboard = "${baseUrls}/dashboard";

}