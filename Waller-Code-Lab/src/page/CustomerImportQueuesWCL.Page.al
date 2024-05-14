page 50102 CustomerImportQueuesWCL
{
    ApplicationArea = All;
    Caption = 'Customer Import Queue';
    PageType = ListPart;
    SourceTable = CustomerImportQueueWCL;
    InsertAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(EntryNo; Rec.EntryNo)
                {
                    ToolTip = 'Specifies the value of the Entry No. field.';
                    Style = StandardAccent;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                    Style = StandardAccent;
                }
                field(Name2; Rec.Name2)
                {
                    ToolTip = 'Specifies the value of the Name 2 field.';
                }
                field(Address; Rec.Address)
                {
                    ToolTip = 'Specifies the value of the Address field.';
                }
                field(Address2; Rec.Address2)
                {
                    ToolTip = 'Specifies the value of the Address 2 field.';
                }
                field(PostCode; Rec.PostCode)
                {
                    ToolTip = 'Specifies the value of the Post Code field.';
                }
                field(PhoneNo; Rec.PhoneNo)
                {
                    ToolTip = 'Specifies the value of the Phone No. field.';
                }
                field(RegistrationNumber; Rec.RegistrationNumber)
                {
                    ToolTip = 'Specifies the value of the Registration Number field.';
                }
                field(VATRegistrationNumber; Rec.VATRegistrationNumber)
                {
                    ToolTip = 'Specifies the value of the VAT Registration Number field.';
                }
                field(Email; Rec.Email)
                {
                    ToolTip = 'Specifies the value of the E-mail field.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(UploadFile)
            {
                ApplicationArea = All;
                Caption = 'Upload File';
                ToolTip = 'Uploads Customer(s) to the Customer Import Queue through your selected file';
                Image = Download;
                trigger OnAction()
                var
                    CustomerImportHandlingWCL: Codeunit CustomerImportHandlingWCL;
                begin
                    CustomerImportHandlingWCL.Run();
                end;
            }
            group(Process)
            {
                action(ProcessCustomer)
                {
                    ApplicationArea = All;
                    Caption = 'Process Customer';
                    ToolTip = 'Processes the Selected Customer.';
                    Image = Process;
                    Scope = Repeater;
                    trigger OnAction()
                    var
                        CustomerImportHandlingWCL: Codeunit CustomerImportHandlingWCL;
                        EmptyQueueMsg: Label 'Customer Import Queue is empty there are no records to import.';
                    begin
                        if Rec.IsEmpty() then begin
                            Message(EmptyQueueMsg);
                            exit;
                        end;
                        CustomerImportHandlingWCL.TransferSingularCustomerFromQueue(Rec);
                    end;
                }
            }
        }
    }
}
