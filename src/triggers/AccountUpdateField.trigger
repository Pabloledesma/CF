trigger AccountUpdateField on Account (before insert, before update)
{
    AccountUpdateField_cls.setAccountUpdate(trigger.new); 
}