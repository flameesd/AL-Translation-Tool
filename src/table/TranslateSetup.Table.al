table 78503 "ESD Translate Setup"
{
    Caption = 'Translate Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; code[10])
        {
            Caption = 'Primary Key';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(20; "Default Source Language"; Code[10])
        {
            Caption = 'Default Source Language';
            TableRelation = Language;
            DataClassification = CustomerContent;
        }

        field(40; "Project Nos."; code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Project Nos.';
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}