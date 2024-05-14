pageextension 50101 CustomerCardWCL extends "Customer Card"
{
    layout
    {
        addlast(General)
        {
            group(ImportedInformation)
            {
                Caption = 'Imported Information';
                Visible = Rec.InfromationImported;
                field(ImportType; Rec.ImportType)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Imported field.';
                }
                field(ImportDate; Rec.ImportDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Import Date field.';
                }
                field(ImportedBy; Rec.ImportedBy)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Imported By field.';
                }
            }
        }
    }
}
