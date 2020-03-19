table 78501 "ESD Dictionary"
{
    Caption = 'Dictionary';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Source Language"; code[10])
        {
            Caption = 'Source Language';
            DataClassification = CustomerContent;
            TableRelation = Language;
            NotBlank = true;
        }
        field(2; "Target Language"; code[10])
        {
            Caption = 'Target Language';
            DataClassification = CustomerContent;
            TableRelation = Language;
            NotBlank = true;
        }
        field(3; "Source Text"; Text[250])
        {
            Caption = 'Source Text';
            DataClassification = CustomerContent;
        }
        field(20; "Target Text"; Text[250])
        {
            Caption = 'Target Text';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Source Language", "Target Language", "Source Text")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        translateSetup: Record "ESD Translate Setup";
    begin
        if "Source Language" <> '' then begin
            translateSetup.Get();
            "Source Language" := translateSetup."Default Source Language";
        end;
    end;
}