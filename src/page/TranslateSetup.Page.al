page 78503 "ESD Translate Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Translate Setup';
    SourceTable = "ESD Translate Setup";
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Default Source Language"; "Default Source Language")
                {
                    ApplicationArea = All;

                }

                field("Project Nos."; "Project Nos.")
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Reset();
        if not Get() then begin
            Init();
            Insert(true);
        end;
    end;
}