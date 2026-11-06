class StudentModel
{
  int? id;
  String name;
  String email;
  int age;


  StudentModel({this.id,
    required this.name,
    required this.email,
    required this.age});

  Map<String, dynamic> toMap(){
  return {
    'id':id,
    'name':name,
    'email':email,
    'age':age,
  };
  }

  //FROM MAP

factory StudentModel.fromMap(Map<String, dynamic> map)
{
  return StudentModel(
    id: map['id'] as int,
    name: map['name'] as String,
    email: map['email'] as String,
    age: map['age'] as int,
  );
}

}