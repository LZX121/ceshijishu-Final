classdef app1_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                   matlab.ui.Figure
        ButtonGroup                matlab.ui.container.ButtonGroup
        RIGHTButton_2              matlab.ui.control.RadioButton
        LEFTButton_2               matlab.ui.control.RadioButton
        DOWNButton_2               matlab.ui.control.RadioButton
        UPButton_2                 matlab.ui.control.RadioButton
        LookTimeEditField          matlab.ui.control.NumericEditField
        LookTimeEditFieldLabel     matlab.ui.control.Label
        PrepareTimeEditField       matlab.ui.control.NumericEditField
        PrepareTimeEditFieldLabel  matlab.ui.control.Label
        STARTButton                matlab.ui.control.Button
        SSVEPLabel                 matlab.ui.control.Label
        EditField                  matlab.ui.control.EditField
    end

    
    methods (Access = public)
        
        function results = func(app)
            
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: STARTButton
        function STARTButtonPushed(app, event)

            t = timer;
            t.StartDelay = app.PrepareTimeEditField.Value;
            t.StartFcn = @Prepare;
            t.TimerFcn = @Action;
            t.StopFcn = @End;
            t.Period = app.LookTimeEditField.Value;
            t.TasksToExecute = 2;
            t.ExecutionMode = 'fixedSpacing';
            data_type = app.ButtonGroup.SelectedObject.Text;
            start(t);

            function Prepare(~,Event)
                app.EditField.Value = "Prepare";
                assignin("base","PrepareTime",Event.Data.time);
            end
            function Action(~,Event)
                app.EditField.Value = string(data_type);
                assignin("base","StartTime",datestr(Event.Data.time,'HH:MM:SS.FFF'));
                
            end
            function End(~,Event)
                app.EditField.Value = "End";
                assignin("base","EndTime",datestr(Event.Data.time,'HH:MM:SS.FFF'));
            end
        end

        % Selection changed function: ButtonGroup
        function ButtonGroupSelectionChanged(app, event)
            selectedButton = app.ButtonGroup.SelectedObject;
            data_type = selectedButton.Text;
            assignin("base",'data_type',data_type);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';

            % Create EditField
            app.EditField = uieditfield(app.UIFigure, 'text');
            app.EditField.HorizontalAlignment = 'center';
            app.EditField.FontSize = 30;
            app.EditField.FontColor = [1 0 0];
            app.EditField.Position = [213 296 218 120];

            % Create SSVEPLabel
            app.SSVEPLabel = uilabel(app.UIFigure);
            app.SSVEPLabel.BackgroundColor = [0 1 1];
            app.SSVEPLabel.HorizontalAlignment = 'center';
            app.SSVEPLabel.FontSize = 20;
            app.SSVEPLabel.Position = [58 438 529 27];
            app.SSVEPLabel.Text = 'SSVEP??????????????????';

            % Create STARTButton
            app.STARTButton = uibutton(app.UIFigure, 'push');
            app.STARTButton.ButtonPushedFcn = createCallbackFcn(app, @STARTButtonPushed, true);
            app.STARTButton.Position = [271 73 100 22];
            app.STARTButton.Text = 'START';

            % Create PrepareTimeEditFieldLabel
            app.PrepareTimeEditFieldLabel = uilabel(app.UIFigure);
            app.PrepareTimeEditFieldLabel.HorizontalAlignment = 'right';
            app.PrepareTimeEditFieldLabel.Position = [381 249 78 22];
            app.PrepareTimeEditFieldLabel.Text = 'Prepare Time';

            % Create PrepareTimeEditField
            app.PrepareTimeEditField = uieditfield(app.UIFigure, 'numeric');
            app.PrepareTimeEditField.ValueDisplayFormat = '%.3f';
            app.PrepareTimeEditField.Position = [474 249 100 22];
            app.PrepareTimeEditField.Value = 1;

            % Create LookTimeEditFieldLabel
            app.LookTimeEditFieldLabel = uilabel(app.UIFigure);
            app.LookTimeEditFieldLabel.HorizontalAlignment = 'right';
            app.LookTimeEditFieldLabel.Position = [399 208 61 22];
            app.LookTimeEditFieldLabel.Text = 'Look Time';

            % Create LookTimeEditField
            app.LookTimeEditField = uieditfield(app.UIFigure, 'numeric');
            app.LookTimeEditField.ValueDisplayFormat = '%.3f';
            app.LookTimeEditField.Position = [475 208 100 22];
            app.LookTimeEditField.Value = 1;

            % Create ButtonGroup
            app.ButtonGroup = uibuttongroup(app.UIFigure);
            app.ButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @ButtonGroupSelectionChanged, true);
            app.ButtonGroup.Title = 'Button Group';
            app.ButtonGroup.Position = [58 160 123 137];

            % Create UPButton_2
            app.UPButton_2 = uiradiobutton(app.ButtonGroup);
            app.UPButton_2.Text = 'UP';
            app.UPButton_2.Position = [11 91 58 22];
            app.UPButton_2.Value = true;

            % Create DOWNButton_2
            app.DOWNButton_2 = uiradiobutton(app.ButtonGroup);
            app.DOWNButton_2.Text = 'DOWN';
            app.DOWNButton_2.Position = [11 69 65 22];

            % Create LEFTButton_2
            app.LEFTButton_2 = uiradiobutton(app.ButtonGroup);
            app.LEFTButton_2.Text = 'LEFT';
            app.LEFTButton_2.Position = [11 47 65 22];

            % Create RIGHTButton_2
            app.RIGHTButton_2 = uiradiobutton(app.ButtonGroup);
            app.RIGHTButton_2.Text = 'RIGHT';
            app.RIGHTButton_2.Position = [11 26 65 22];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = app1_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end