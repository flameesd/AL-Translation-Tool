table 78502 "ESD Translate File"
{
    Caption = 'Translate File';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Project Code"; code[20])
        {
            Caption = 'Project Code';
            Editable = false;
            DataClassification = CustomerContent;
            TableRelation = "ESD Translation Project";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(20; "Is Not Translate"; Boolean)
        {
            Caption = 'Is Not Translate';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(30; "Text 1 (1-250)"; Text[250])
        {
            Caption = 'Text 1 (1-250)';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(40; "Text 2 (250-500)"; Text[250])
        {
            Caption = 'Text 2 (250-500)';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(70; "Translate Text"; Text[250])
        {
            Caption = 'Translate Text';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(80; "Translate Type"; Option)
        {
            Caption = 'Translate Type';
            Editable = false;
            OptionMembers = " ","Source","Target";
            OptionCaption = ' ,Source,Target';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Project Code", "Line No.")
        {
            Clustered = true;
        }
        key(TransType; "Translate Type")
        {

        }
    }
}