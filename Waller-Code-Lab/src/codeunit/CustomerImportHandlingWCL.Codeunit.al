codeunit 50100 CustomerImportHandlingWCL
{
    var
        CustomerImportWCL: Record CustomerImportWCL;
        TempCSVBuffer: Record "CSV Buffer" temporary;
        EmailFilterLbl: Label '@%1', Comment = '%1 = the email, here I am making sure the case of the characters does not matter';

    trigger OnRun()
    var
        XMLCustomerImportWCL: XmlPort XMLCustomerImportWCL;
        BlankFileTypeErr: Label 'Ensure the File type field is not blank.';
        SelectFileTxt: Label 'Select a File';
        Ins: InStream;
        FileName: Text;
    begin
        CustomerImportWCL.Get();
        case CustomerImportWCL.FileType of
            ImportFileTypeWCL::CSV:
                begin
                    if not UploadIntoStream(SelectFileTxt, '', '', FileName, Ins) then
                        exit;
                    TempCSVBuffer.DeleteAll(false);
                    ImportFromCSV(Ins);
                end;
            ImportFileTypeWCL::JSON:
                begin
                    if not UploadIntoStream(SelectFileTxt, '', '', FileName, Ins) then
                        exit;
                    ImportFromJson(Ins);
                end;
            ImportFileTypeWCL::XML:
                XMLCustomerImportWCL.Run();
            else
                Error(BlankFileTypeErr);
        end;
    end;
    #region JSON Importing
    local procedure ImportFromJson(Ins: InStream)
    var
        CustomerObject: JsonObject;
        JsonFile: JsonObject;
        JsonCustomersToken: JsonToken;
        CustomerToken: JsonToken;
        JsonCustomersArray: JsonArray;
        CustomersKeyLbl: Label 'customers';
    begin
        JsonFile.ReadFrom(Ins);
        if not JsonFile.Get(CustomersKeyLbl, JsonCustomersToken) then
            exit;
        JsonCustomersArray := JsonCustomersToken.AsArray();
        foreach CustomerToken in JsonCustomersArray do begin
            CustomerObject := CustomerToken.AsObject();
            if not CustomerExistsinQueueJson(CustomerObject) then
                CreateJSONQueueEntry(CustomerObject);
        end;
    end;

    local procedure CustomerExistsinQueueJson(var JsonCustomer: JsonObject): Boolean
    var
        CustomerImportQueueWCL: Record CustomerImportQueueWCL;
        EmailKeyLbl: Label 'email';
    begin
        CustomerImportQueueWCL.Reset();
        CustomerImportQueueWCL.SetFilter(Email, '%1&<>%2', StrSubstNo(EmailFilterLbl, GetJsonFileValue(JsonCustomer, EmailKeyLbl)), ' ');
        if CustomerImportQueueWCL.IsEmpty() then
            exit(false);
        exit(true);
    end;

    local procedure CreateJSONQueueEntry(JsonCustomer: JsonObject)
    var
        CustomerImportQueueWCL: Record CustomerImportQueueWCL;
        NameKeyLbl: Label 'name';
        Name2KeyLbl: Label 'name2';
        AddressKeyLbl: Label 'address';
        Address2KeyLbl: Label 'address2';
        PostcodeKeyLbl: Label 'postcode';
        PhoneNoKeyLbl: Label 'phonenumber';
        RegNoKeyLbl: Label 'registrationnumber';
        VATRegNoKeyLbl: Label 'vatregistrationnumber';
        EmailKeyLbl: Label 'email';
    begin
        CustomerImportQueueWCL.Init();
        CustomerImportQueueWCL.EntryNo := 0;
        CustomerImportQueueWCL.Validate(Name, GetJsonFileValue(JsonCustomer, NameKeyLbl));
        CustomerImportQueueWCL.Validate(Name2, GetJsonFileValue(JsonCustomer, Name2KeyLbl));
        CustomerImportQueueWCL.Validate(Address, GetJsonFileValue(JsonCustomer, AddressKeyLbl));
        CustomerImportQueueWCL.Validate(Address2, GetJsonFileValue(JsonCustomer, Address2KeyLbl));
        CustomerImportQueueWCL.Validate(PostCode, GetJsonFileValue(JsonCustomer, PostcodeKeyLbl));
        CustomerImportQueueWCL.Validate(PhoneNo, GetJsonFileValue(JsonCustomer, PhoneNoKeyLbl));
        CustomerImportQueueWCL.Validate(RegistrationNumber, GetJsonFileValue(JsonCustomer, RegNoKeyLbl));
        CustomerImportQueueWCL.Validate(VATRegistrationNumber, GetJsonFileValue(JsonCustomer, VATRegNoKeyLbl));
        CustomerImportQueueWCL.Validate(Email, GetJsonFileValue(JsonCustomer, EmailKeyLbl));
        CustomerImportQueueWCL.Insert(true);
    end;

    local procedure GetJsonFileValue(var JsonCustomer: JsonObject; JsonKey: Text) TextFileValue: Text;
    var
        JsonFileValue: JsonToken;
    begin
        if JsonCustomer.Get(JsonKey, JsonFileValue) then
            TextFileValue := JsonFileValue.AsValue().AsText();
    end;
    #endregion

    #region CSV Importing
    local procedure ImportFromCSV(Ins: InStream)
    var
        LineNo: Integer;
    begin
        TempCSVBuffer.LoadDataFromStream(Ins, ',');
#pragma warning disable AA0005  //Begin and end seems to be needed here for a for loop
        for LineNo := 1 to TempCSVBuffer.GetNumberOfLines() do begin
            if LineNo <> 1 then
                if not CustomerExistsinQueueCSV(LineNo) then
                    CreateCSVQueueEntry(LineNo);
        end;
#pragma warning restore AA0005
    end;

    local procedure CustomerExistsinQueueCSV(LineNo: Integer): Boolean
    var
        CustomerImportQueueWCL: Record CustomerImportQueueWCL;
    begin
        CustomerImportQueueWCL.Reset();
        CustomerImportQueueWCL.SetFilter(Email, '%1&<>%2', StrSubstNo(EmailFilterLbl, (GetCSVTextValue(LineNo, 9))), ' ');
        if CustomerImportQueueWCL.IsEmpty() then
            exit(false);
        exit(true);
    end;

    local procedure CreateCSVQueueEntry(LineNo: Integer)
    var
        CustomerImportQueueWCL: Record CustomerImportQueueWCL;
    begin
        CustomerImportQueueWCL.Init();
        CustomerImportQueueWCL.EntryNo := 0;
        CustomerImportQueueWCL.Validate(Name, GetCSVTextValue(LineNo, 1));
        CustomerImportQueueWCL.Validate(Name2, GetCSVTextValue(LineNo, 2));
        CustomerImportQueueWCL.Validate(Address, GetCSVTextValue(LineNo, 3));
        CustomerImportQueueWCL.Validate(Address2, GetCSVTextValue(LineNo, 4));
        CustomerImportQueueWCL.Validate(PostCode, GetCSVTextValue(LineNo, 5));
        CustomerImportQueueWCL.Validate(PhoneNo, GetCSVTextValue(LineNo, 6));
        CustomerImportQueueWCL.Validate(RegistrationNumber, GetCSVTextValue(LineNo, 7));
        CustomerImportQueueWCL.Validate(VATRegistrationNumber, GetCSVTextValue(LineNo, 8));
        CustomerImportQueueWCL.Validate(EMail, GetCSVTextValue(LineNo, 9).ToLower());
        CustomerImportQueueWCL.Insert(true);
    end;

    local procedure GetCSVTextValue(LineNo: Integer; FieldNo: Integer): Text
    begin
        if TempCSVBuffer.Get(LineNo, FieldNo) then
            exit(TempCSVBuffer.Value.TrimStart('"').TrimEnd('"'));
    end;

    local procedure GetCSVDateValue(LineNo: Integer; FieldNo: Integer): Date
    var
        DateValue: Date;
    begin
        if TempCSVBuffer.Get(LineNo, FieldNo) then begin
            Evaluate(DateValue, TempCSVBuffer.Value.TrimStart('"').TrimEnd('"'));
            exit(DateValue);
        end;
    end;

    local procedure GetCSVIntegerValue(LineNo: Integer; FieldNo: Integer): Integer
    var
        IntegerValue: Integer;
    begin
        if TempCSVBuffer.Get(LineNo, FieldNo) then begin
            Evaluate(IntegerValue, TempCSVBuffer.Value.TrimStart('"').TrimEnd('"'));
            exit(IntegerValue);
        end;
    end;

    local procedure GetCSVDecimalValue(LineNo: Integer; FieldNo: Integer): Decimal
    var
        DecimalValue: Decimal;
    begin
        if TempCSVBuffer.Get(LineNo, FieldNo) then begin
            Evaluate(DecimalValue, TempCSVBuffer.Value.TrimStart('"').TrimEnd('"'));
            exit(DecimalValue);
        end;
    end;
    #endregion

    #region Processing Import Queue
    internal procedure TransferImportQueuetoCustomers()
    var
        ExistingCustomer: Record Customer;
        CustomerImportQueueWCL: Record CustomerImportQueueWCL;
        EmptyQueueMsg: Label 'Customer Import Queue is empty there are no records to import.';
        ProcessedMsg: Label 'Customer Import Queue has been imported.';
    begin
        if not CustomerImportQueueWCL.FindSet() then begin
            Message(EmptyQueueMsg);
            exit;
        end;
        repeat
            ExistingCustomer.SetFilter("E-Mail", '%1&<>%2', StrSubstNo(EmailFilterLbl, CustomerImportQueueWCL.Email), ' ');
            if not ExistingCustomer.FindFirst() then
                CreateCustomer(CustomerImportQueueWCL)
            else
                ModifyCustomer(ExistingCustomer, CustomerImportQueueWCL);
        until CustomerImportQueueWCL.Next() = 0;
        CustomerImportQueueWCL.DeleteAll(true);
        Message(ProcessedMsg);
    end;

    internal procedure TransferSingularCustomerFromQueue(var CustomerImportQueueWCL: Record CustomerImportQueueWCL)
    var
        ExistingCustomer: Record Customer;
        ProcessedMsg: Label 'The selected customer has been processed.';
    begin
        ExistingCustomer.SetFilter("E-Mail", '%1&<>%2', StrSubstNo(EmailFilterLbl, CustomerImportQueueWCL.Email), ' ');
        if not ExistingCustomer.FindFirst() then
            CreateCustomer(CustomerImportQueueWCL)
        else
            ModifyCustomer(ExistingCustomer, CustomerImportQueueWCL);
        CustomerImportQueueWCL.Delete(true);
        Message(ProcessedMsg);
    end;


    local procedure CreateCustomer(CustomerImportQueueWCL: Record CustomerImportQueueWCL)
    var
        Customer: Record Customer;
    begin
        Customer.Init();
        Customer.SetImporting();
        Customer.Validate(Name, CustomerImportQueueWCL.Name);
        Customer.Validate("Name 2", CustomerImportQueueWCL.Name2);
        Customer.Validate(Address, CustomerImportQueueWCL.Address);
        Customer.Validate("Address 2", CustomerImportQueueWCL.Address2);
        Customer.Validate("Post Code", CustomerImportQueueWCL.PostCode);
        Customer.Validate("Phone No.", CustomerImportQueueWCL.PhoneNo);
        Customer.Validate("Registration Number", CustomerImportQueueWCL.RegistrationNumber);
        Customer.Validate("VAT Registration No.", CustomerImportQueueWCL.VATRegistrationNumber);
        Customer.Validate("E-Mail", CustomerImportQueueWCL.Email);
        SetImportInformation(Customer, true);
        Customer.Insert(true);
    end;

    local procedure ModifyCustomer(var ExistingCustomer: Record Customer; CustomerImportQueueWCL: Record CustomerImportQueueWCL)
    begin
        ExistingCustomer.Validate(Name, CustomerImportQueueWCL.Name);
        ExistingCustomer.Validate("Name 2", CustomerImportQueueWCL.Name2);
        ExistingCustomer.Validate(Address, CustomerImportQueueWCL.Address);
        ExistingCustomer.Validate("Address 2", CustomerImportQueueWCL.Address2);
        ExistingCustomer.Validate("Post Code", CustomerImportQueueWCL.PostCode);
        ExistingCustomer.Validate("Phone No.", CustomerImportQueueWCL.PhoneNo);
        ExistingCustomer.Validate("Registration Number", CustomerImportQueueWCL.RegistrationNumber);
        ExistingCustomer.Validate("VAT Registration No.", CustomerImportQueueWCL.VATRegistrationNumber);
        ExistingCustomer.Validate("E-Mail", CustomerImportQueueWCL.Email);
        SetImportInformation(ExistingCustomer, false);
        ExistingCustomer.Modify(true);
    end;

    local procedure SetImportInformation(var Customer: Record Customer; NewRecord: Boolean)
    begin
        Customer.Validate(InfromationImported, true);
        if NewRecord then
            Customer.Validate(ImportType, Customer.ImportType::Creation)
        else
            Customer.Validate(ImportType, Customer.ImportType::Modification);
        Customer.Validate(ImportDate, CurrentDateTime());
        Customer.Validate(ImportedBy, UserId());
    end;
    #endregion Processing Import Queue
}
