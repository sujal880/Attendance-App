class UserModel{
  String? uid;
  String? email;
  String? phone;
  String? fullname;
  String? profilepic;
  String? organization;
  String? desicnation;

  UserModel({this.uid,this.email,this.phone,this.desicnation,this.organization,this.fullname,this.profilepic});
  UserModel.fromMap(Map<String,dynamic>map){
    uid=map["uid"];
    email=map["email"];
    phone=map["phone"];
    phone=map["phone"];
    fullname=map["fullname"];
    profilepic=map["profilepic"];
    organization=map["organization"];
    desicnation=map["desicnation"];
  }
  Map<String,dynamic>toMap(){
    return {
      "uid":uid,
      "email":email,
      "phone":phone,
      "fullname":fullname,
      "profilepic":profilepic,
      "organization":organization,
      "desicnation":desicnation
    };
}
}