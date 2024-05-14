tableextension 50101 CustomerWCL extends Customer
{
    fields
    {
        field(50100; InfromationImported; Boolean)
        {
            Caption = 'Imported';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50101; ImportDate; DateTime)
        {
            Caption = 'Import Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50102; ImportedBy; Text[50])
        {
            Caption = 'Imported By';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(501003; ImportType; Option)
        {
            Caption = 'Import Type';
            DataClassification = CustomerContent;
            OptionMembers = ,Creation,Modification;
            Editable = false;
        }
    }
    internal procedure SetImporting()
    begin
        Importing := true;
    end;

    internal procedure GetImporting(): Boolean
    begin
        exit(Importing);
    end;

    var
        Importing: Boolean;
}
