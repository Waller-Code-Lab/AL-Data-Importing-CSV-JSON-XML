xmlport 50100 XMLCustomerImportWCL
{
    Caption = 'Customer Import';
    Direction = Import;
    Encoding = UTF8;
    Format = Xml;
    UseRequestPage = false;
    schema
    {
        textelement(customers)
        {
            XmlName = 'customers';
            tableelement(CustomerImportQueueWCL; CustomerImportQueueWCL)
            {
                XmlName = 'customer';
                fieldelement(entrynumber; CustomerImportQueueWCL.EntryNo)
                {
                    XmlName = 'entrynumber';
                    MinOccurs = Once;
                    MaxOccurs = Once;
                }
                fieldelement(name; CustomerImportQueueWCL.Name)
                {
                    XmlName = 'name';
                    MinOccurs = Once;
                    MaxOccurs = Once;
                }
                fieldelement(name2; CustomerImportQueueWCL.Name2)
                {
                    XmlName = 'name2';
                }
                fieldelement(address; CustomerImportQueueWCL.Address)
                {
                    XmlName = 'address';
                }
                fieldelement(address2; CustomerImportQueueWCL.Address2)
                {
                    XmlName = 'address2';
                }
                fieldelement(postcode; CustomerImportQueueWCL.PostCode)
                {
                    XmlName = 'postcode';
                }
                fieldelement(phonenumber; CustomerImportQueueWCL.PhoneNo)
                {
                    XmlName = 'phonenumber';
                }
                fieldelement(registrationnumber; CustomerImportQueueWCL.RegistrationNumber)
                {
                    XmlName = 'registrationnumber';
                }
                fieldelement(vatregistrationnumber; CustomerImportQueueWCL.VATRegistrationNumber)
                {
                    XmlName = 'vatregistrationnumber';
                }
                fieldelement(email; CustomerImportQueueWCL.Email)
                {
                    XmlName = 'email';
                    MinOccurs = Once;
                    MaxOccurs = Once;
                }
                trigger OnBeforeInsertRecord()
                var
                    FullCustomerImportQueue: Record CustomerImportQueueWCL;
                    EmailFilterLbl: Label '@%1', Comment = '%1 = the email, here I am making sure the case of the characters does not matter';
                begin
                    FullCustomerImportQueue.Reset();
                    FullCustomerImportQueue.SetFilter(Email, '%1&<>%2', StrSubstNo(EmailFilterLbl, CustomerImportQueueWCL.Email), ' ');
                    if not FullCustomerImportQueue.IsEmpty() then
                        currXMLport.Skip();
                end;
            }
        }
    }
}
