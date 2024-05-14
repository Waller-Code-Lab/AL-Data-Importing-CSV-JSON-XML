table 50101 CustomerImportQueueWCL
{
    Caption = 'Customer Import Queue';
    DataClassification = CustomerContent;

    fields
    {
        field(1; EntryNo; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; Name; Text[100])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(3; Name2; Text[50])
        {
            Caption = 'Name 2';
            DataClassification = CustomerContent;
        }
        field(4; Address; Text[100])
        {
            Caption = 'Address';
            DataClassification = CustomerContent;
        }
        field(5; Address2; Text[50])
        {
            Caption = 'Address 2';
            DataClassification = CustomerContent;
        }
        field(6; PostCode; Code[20])
        {
            Caption = 'Post Code';
            DataClassification = CustomerContent;
        }
        field(7; PhoneNo; Text[30])
        {
            Caption = 'Phone No.';
            DataClassification = CustomerContent;
        }
        field(8; RegistrationNumber; Text[50])
        {
            Caption = 'Registration Number';
            DataClassification = CustomerContent;
        }
        field(9; VATRegistrationNumber; Text[20])
        {
            Caption = 'VAT Registration Number';
            DataClassification = CustomerContent;
        }
        field(10; Email; Text[80])
        {
            Caption = 'E-mail';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; EntryNo)
        {
            Clustered = true;
        }
        key(Key2; Email)
        {

        }
    }
}
