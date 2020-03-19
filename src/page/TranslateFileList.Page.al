page 78502 "ESD Translate File List"
{
    PageType = List;
    UsageCategory = None;
    Caption = 'Translate File List';
    SourceTable = "ESD Translate File";
    InsertAllowed = false;
    Editable = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("Project Code"; "Project Code")
                {
                    ApplicationArea = All;
                }

                field("Line No."; "Line No.")
                {
                    ApplicationArea = All;
                }

                field("Is Not Translate"; "Is Not Translate")
                {
                    ApplicationArea = All;
                }

                field(Description; AllText)
                {
                    Caption = 'Description';
                    ApplicationArea = All;
                }

                field("Translate Type"; "Translate Type")
                {
                    ApplicationArea = All;
                }

                field("Translate Text"; "Translate Text")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    var
        AllText: Text;

    trigger OnAfterGetCurrRecord()
    begin
        AllText := "Text 1 (1-250)" + "Text 2 (250-500)";
    end;
}