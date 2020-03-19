page 78501 "ESD Dictionary List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Dictionary List';
    SourceTable = "ESD Dictionary";

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("Source Language"; "Source Language")
                {
                    ApplicationArea = All;
                    Visible = IsVisible;
                }

                field("Target Language"; "Target Language")
                {
                    ApplicationArea = All;
                    Visible = IsVisible;
                }

                field("Source Text"; "Source Text")
                {
                    ApplicationArea = All;
                }

                field("Target Text"; "Target Text")
                {
                    ApplicationArea = All;
                }
            }
        }

    }

    actions
    {
        area(Processing)
        {
            action("Import Translate File")
            {
                ApplicationArea = All;
                Caption = 'Import Translate File';
                Image = Import;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    translationMgt: Codeunit "ESD Translation Mgt.";
                begin
                    translationMgt.ImportTranslateFile();
                end;
            }

        }
    }

    trigger OnOpenPage()
    begin
        if not IsOpenWithProject then
            IsVisible := true;
    end;

    procedure SetOpenWithProject(GetOpen: Boolean)
    begin
        IsOpenWithProject := GetOpen;
    end;

    var
        IsVisible: Boolean;
        IsOpenWithProject: Boolean;
}