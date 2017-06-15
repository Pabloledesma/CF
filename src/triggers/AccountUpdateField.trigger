trigger AccountUpdateField on Account (before update)
{
    AccountUpdateField_cls.setAccountUpdate(trigger.new); 
}