page 50100 CustomerImportWCL
{
    ApplicationArea = All;
    Caption = 'Customer Import';
    PageType = Card;
    SourceTable = CustomerImportWCL;
    UsageCategory = Documents;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(FileType; Rec.FileType)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the File Type you would like to use when importing customers.';
                }
            }
            part(CustomerImportQueue; CustomerImportQueuesWCL)
            {
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ProcessImportQueue)
            {
                ApplicationArea = All;
                Caption = 'Process Import Queue';
                ToolTip = 'Imports Customers or Modifies a Customer if a Customer with the same email already exists - through a file of your choice';
                Image = Process;
                trigger OnAction()
                var
                    CustomerImportHandlingWCL: Codeunit CustomerImportHandlingWCL;
                    ContinueQst: Label 'Would you like to continue and process the Customer Import Queue?';
                begin
                    if Confirm(ContinueQst, false) then
                        CustomerImportHandlingWCL.TransferImportQueuetoCustomers();
                end;
            }
        }
        area(Promoted)
        {
            actionref(ImportCustomersPromoted; ProcessImportQueue)
            {
            }
        }
    }
    trigger OnOpenPage()
    begin
        if Rec.IsEmpty() then
            Rec.Insert();
    end;
}
