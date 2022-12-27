enum ChatEnum{
  text("text"),
  image("image"),
  audio("audio"),
  video("video"),
  gif("gif");

  const ChatEnum(this.type);
  final String type;
}

extension ConvertChat on String{
  ChatEnum toEnum(){
    switch (this) {
      case "audio":
        return ChatEnum.audio;
      case "image":
        return ChatEnum.image;
      case "text":
        return ChatEnum.text;
      case "video":
        return ChatEnum.video;
      case "gif":
        return ChatEnum.gif; 
      default:
      return ChatEnum.text;
    }
  }
}