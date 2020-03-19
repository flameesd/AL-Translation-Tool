page 78500 "ESD Translation Project List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Translation Project List';
    SourceTable = "ESD Translation Project";
    LinksAllowed = false;

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

                field("Project Name"; "Project Name")
                {
                    ApplicationArea = All;
                }

                field("Source Language"; "Source Language")
                {
                    ApplicationArea = All;
                }

                field("Target Language"; "Target Language")
                {
                    ApplicationArea = All;
                }

                field("File Location"; "File Location")
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
                PromotedIsBig = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    dic: Record "ESD Dictionary";
                    dicList: Page "ESD Dictionary List";
                begin
                    dic.FilterGroup(2);
                    dic.SetRange("Source Language", "Source Language");
                    dic.SetRange("Target Language", "Target Language");
                    dic.FilterGroup(0);
                    dicList.SetTableView(dic);
                    dicList.SetOpenWithProject(true);
                    dicList.RunModal();
                end;
            }

            action("Translate Note")
            {
                ApplicationArea = All;
                Caption = 'Translate Note';
                Image = Translate;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    tranNote: Record "ESD Translate Note";
                    tranNotes: Page "ESD Translate Notes";
                begin
                    tranNote.FilterGroup(2);
                    tranNote.SetRange("Project Code", "Project Code");
                    tranNote.FilterGroup(0);
                    tranNotes.SetTableView(tranNote);
                    tranNotes.RunModal();
                end;
            }
            action("Translate File")
            {
                ApplicationArea = All;
                Caption = 'Translate File';
                Image = DataEntry;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    tranFile: Record "ESD Translate File";
                    tranFiles: Page "ESD Translate File List";
                begin
                    tranFile.FilterGroup(2);
                    tranFile.SetRange("Project Code", "Project Code");
                    tranFile.FilterGroup(0);
                    tranFiles.SetTableView(tranFile);
                    tranFiles.RunModal();
                end;
            }
        }

        area(Processing)
        {
            action("Import File")
            {
                ApplicationArea = All;
                Caption = 'Import File';
                Image = Import;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    translationMgt: Codeunit "ESD Translation Mgt.";
                begin
                    translationMgt.ImportTranslateFile("Project Code");
                end;
            }

            action("Export File")
            {
                ApplicationArea = All;
                Caption = 'Export File';
                Image = Export;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    translationMgt: Codeunit "ESD Translation Mgt.";
                begin
                    translationMgt.ExportTranslateFile("Project Code");
                end;
            }

            action("Delete Data")
            {
                ApplicationArea = All;
                Caption = 'Delete Data';
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    translationMgt: Codeunit "ESD Translation Mgt.";
                begin
                    translationMgt.DeleteTranslateData("Project Code", true);
                end;
            }
        }
    }
}