codeunit 50101 CustSubscriptionsWCL
{
    [EventSubscriber(ObjectType::Table, DataBase::Customer, OnBeforeVATRegistrationValidation, '', true, false)]
    local procedure MyProcedure(var Customer: Record Customer; var IsHandled: Boolean)
    begin
        IsHandled := Customer.GetImporting();
    end;
}
