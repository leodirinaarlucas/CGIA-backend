import Routing
import Vapor
import Crypto
import Authentication

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {
    let studentController = StudentController()
    try router.register(collection: studentController)
    let instructorController = InstructorController()
    try router.register(collection: instructorController)
    let subjectController = SubjectController()
    try router.register(collection: subjectController)
    let classroomController = ClassroomController()
    try router.register(collection: classroomController)
    let userController = UserController()
    try router.register(collection: userController)
    let adminController = AdminController()
    try router.register(collection: adminController)
    let studentClassroomController = StudentClassroomController()
    try router.register(collection: studentClassroomController)
    let gradeController = GradeController()
    try router.register(collection: gradeController)
}
