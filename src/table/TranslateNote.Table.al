table 78504 "ESD Translate Note"
{
    Caption = 'Translate Note';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Project Code"; code[20])
        {
            Caption = 'Project Code';
            NotBlank = true;
            DataClassification = CustomerContent;
            TableRelation = "ESD Translation Project";
        }
        field(2; "Source Language"; Code[10])
        {
            Caption = 'Source Language';
            DataClassification = CustomerContent;
            TableRelation = Language;
            NotBlank = true;
        }
        field(3; "Target Language"; Code[10])
        {
            Caption = 'Target Language';
            DataClassification = CustomerContent;
            TableRelation = Language;
            NotBlank = true;
        }
        field(4; "Source Text"; Text[250])
        {
            Caption = 'Source Text';
            DataClassification = CustomerContent;
        }
        field(20; "Target Text"; Text[250])
        {
            Caption = 'Target Text';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                TransMgt: Codeunit 78500;
            begin
                if "Target Text" <> '' then begin
                    TransMgt.UpdateTranslateFileEditTarget("Project Code", Rec);
                    "Is Translated" := true;
                    "Translated by Web" := false;
                    TransMgt.UpdateDictionaryFromNote(Rec);
                end else
                    "Is Translated" := false;
            end;
        }
        field(30; "Is Translated"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }

        field(40; "Translated by Web"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Project Code", "Source Language", "Source Text")
        {
            Clustered = true;
        }
    }
}