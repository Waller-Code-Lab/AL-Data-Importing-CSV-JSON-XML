table 50100 CustomerImportWCL
{
    Caption = 'Customer Import';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Code; Code[10])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(2; FileType; enum ImportFileTypeWCL)
        {
            Caption = 'File Type';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }
}
