
class ScriptProfileJS implements ScriptProfile native "*ScriptProfile" {

  ScriptProfileNodeJS get head() native "return this.head;";

  String get title() native "return this.title;";

  int get uid() native "return this.uid;";

  var dartObjectLocalStorage;

  String get typeName() native;
}
