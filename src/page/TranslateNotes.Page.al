page 78504 "ESD Translate Notes"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Translate Notes';
    SourceTable = "ESD Translate Note";
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("Source Text"; "Source Text")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Is Tranlated"; "Is Translated")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Target Text"; "Target Text")
                {
                    ApplicationArea = All;

                }
                field("Translated by Web"; "Translated by Web")
                {
                    ApplicationArea = All;

                }

            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(Dictionary)
            {
                ApplicationArea = All;
                Caption = 'Dictionary';
                Image = Translate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    dic: Record "ESD Dictionary";
                    dicList: Page "ESD Dictionary List";
                begin
                    dic.FilterGroup(2);
                    dic.SetRange("Source Language", "Source Language");
                    dic.FilterGroup(0);
                    dicList.SetTableView(dic);
                    dicList.SetOpenWithProject(true);
                    dicList.RunModal();
                end;
            }
        }

        area(Processing)
        {
            action("Add Source Text")
            {
                ApplicationArea = All;
                Caption = 'Add Source Text';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    TranslateMgt: Codeunit "ESD Translation Mgt.";
                begin
                    TranslateMgt.AddSourceText("Project Code");
                end;
            }

            action("Translate All")
            {
                ApplicationArea = All;
                Caption = 'Translate All';
                Image = Translate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    TranslateMgt: Codeunit "ESD Translation Mgt.";
                begin
                    TranslateMgt.TranslateAll("Project Code");
                end;
            }

            action("Translate Line")
            {
                ApplicationArea = All;
                Caption = 'Translate Lines';
                Image = Translate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    translateNote: Record "ESD Translate Note";
                    TranslateMgt: Codeunit "ESD Translation Mgt.";
                begin
                    CurrPage.SetSelectionFilter(translateNote);
                    if translateNote.FindSet() then
                        repeat
                            TranslateMgt.TranslateLine("Project Code", translateNote."Source Text");
                        until translateNote.Next() = 0;
                end;
            }
        }
    }
}