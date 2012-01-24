
class Int16ArrayJS extends ArrayBufferViewJS implements Int16Array, List<int> native "*Int16Array" {

  factory Int16Array(int length) =>  _construct(length);

  factory Int16Array.fromList(List<int> list) => _construct(list);

  factory Int16Array.fromBuffer(ArrayBuffer buffer) => _construct(buffer);

  static _construct(arg) native 'return new Int16Array(arg);';

  static final int BYTES_PER_ELEMENT = 2;

  int get length() native "return this.length;";

  int operator[](int index) native;

  void operator[]=(int index, int value) native;

  void setElements(Object array, [int offset = null]) native;

  Int16ArrayJS subarray(int start, [int end = null]) native;
}
