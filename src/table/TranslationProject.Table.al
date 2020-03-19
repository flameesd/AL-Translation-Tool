table 78500 "ESD Translation Project"
{
    Caption = 'Translation Project';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Project Code"; code[20])
        {
            Caption = 'Project Code';
            DataClassification = CustomerContent;
            trigger OnValidate();
            var
                translateSetup: Record "ESD Translate Setup";
                translationMgt: Codeunit "ESD Translation Mgt.";
                noSeriesMgt: Codeunit NoSeriesManagement;
            begin
                if "Project Code" <> xRec."Project Code" then begin
                    translationMgt.DeleteTranslateData(xRec."Project Code", false);
                    translateSetup.Get();
                    noSeriesMgt.TestManual(translateSetup."Project Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(20; "Project Name"; Text[250])
        {
            Caption = 'Project Name';
            DataClassification = CustomerContent;
        }
        field(30; "Source Language"; Code[10])
        {
            Caption = 'Source Language';
            DataClassification = CustomerContent;
            TableRelation = Language;
            NotBlank = true;
        }
        field(40; "Target Language"; Code[10])
        {
            Caption = 'Target Language';
            DataClassification = CustomerContent;
            TableRelation = Language;
        }
        field(50; "File Location"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'File Location';
            trigger OnLookup()
            var
                fileMgt: Codeunit "File Management";
            begin
                "File Location" := copystr(fileMgt.OpenFileDialog('NAV File Browser', '', '*XLF files (*.xlf)|*.xlf|All files (*.*)|*.*'), 1, MaxStrLen("File Location"));
            end;
        }
        field(100; "No. Series"; Code[20])
        {
            Editable = false;
            Caption = 'No. Series';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Project Code")
        {
            Clustered = true;
        }
    }

    var
        TransProject: Record "ESD Translation Project";

    trigger OnInsert()
    var
        translateSetup: Record "ESD Translate Setup";
        noSeriesMgt: Codeunit NoSeriesManagement;
    begin
        translateSetup.Get();
        "Source Language" := translateSetup."Default Source Language";
        if "Project Code" = '' then begin
            translateSetup.get();
            translateSetup.TestField("Project Nos.");
            noSeriesMgt.InitSeries(translateSetup."Project Nos.", xRec."No. Series", 0D, "Project Code", "No. Series");
            translateSetup.TestField("Default Source Language");
            if "Source Language" = '' then
                validate("Source Language", translateSetup."Default Source Language");
        end;
    end;

    trigger OnDelete()
    var
        translationMgt: Codeunit "ESD Translation Mgt.";
    begin
        translationMgt.DeleteTranslateData("Project Code", false);
    end;

    procedure AssistEdit(): Boolean;
    var
        translateSetup: Record "ESD Translate Setup";
        noSeriesMgt: Codeunit NoSeriesManagement;
    begin
        with TransProject do begin
            TransProject := Rec;
            translateSetup.get();
            translateSetup.TestField("Project Nos.");
            if noSeriesMgt.SelectSeries(translateSetup."Project Nos.", xRec."No. Series", "No. Series") then begin
                noSeriesMgt.SetSeries("Project Code");
                Rec := TransProject;
                exit(true);
            end;
        end;
    end;
}