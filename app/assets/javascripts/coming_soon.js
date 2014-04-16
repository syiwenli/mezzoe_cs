'use strict';

var MEZZOE = (function(){

    $.validator.addMethod("validate_email", function(value, element) {
        return this.optional(element) || (/^([\w_.+-])+@(([\w-])+\.)+([\w]{2,4})+$/).test(value);
    }, I18n.t('activemodel.user.error.email.format'));

    var answer, previous_id, question,
        startQuestions = I18n.t('survey.questions.start_question'),
        pat = /^question_\d$/,
        digital_bool = '0',
        $btns = $('.btn'),
        $questionDiv = $('.question'),
        $surveyBox = $('#survey'),
        $notice = $('.notice'),
        $qAndA = $('#q_and_a'),
        $comingSoon = $('#coming_soon'),
        $newUser = $('#new_user'),
        $userSurvey = $('#user_survey'),
        $emailError = $('#email_error');

    var event_handlers = {
        show_notice: function() {
            if ($notice.size() > 0) {
                $surveyBox.hide();
                return true;
            }
            else if ($emailError.text().trim().length > 0){
                $questionDiv.hide();
                $btns.hide();
                $comingSoon.removeClass('hidden').addClass('show_inline');
                return true;
            }
            else {
                return false;
            }
        },

        get_answer: function(btn) {
            return $(btn).val().toLowerCase();
        },

        get_question_id: function() {
            return $questionDiv.attr('id');
        },

        show_next_question: function(answer, previous_id) {

            if (answer == 'yes') {
                digital_bool = '1'
            } else {
                digital_bool = '0'
            }
            question = I18n.t("survey.questions." + answer + "_to_" + previous_id + ".question_" + previous_id + digital_bool);
            $questionDiv.attr('id', previous_id + digital_bool);

            //  if question points to another start question, and make sure it actually exists
            if (question.match(pat) && startQuestions.hasOwnProperty(question)) {
                $questionDiv.attr('id', question.match(/\d/));
                question = I18n.t("survey.questions.start_question." + question);
            }
            // if question points to the final question
            if (question == 'fin_question') {
                question = I18n.t("survey.questions.fin_question");
                $questionDiv.attr('id', 'fin');
            }
            // if question points to the final result
            if (question == 'fin_negative' || question == 'fin_positive') {
                question = I18n.t("survey.questions." + question);
                $btns.hide();
                $comingSoon.removeClass('hidden').addClass('show_inline');
            }
            $questionDiv.text(question);
        },

        select_answer: function() {
            $surveyBox.on('click', '.btn', function () {
                answer = event_handlers.get_answer(this);
                previous_id = event_handlers.get_question_id();
                event_handlers.show_next_question(answer, previous_id);
                $qAndA.data(previous_id, answer);
            })
        },

        validate_email_form: function() {
            $newUser.validate({
                rules: {
                    "user[email]": {
                        required: true,
                        validate_email: true
                    }
                },
                messages: {
                    "user[email]": {
                        required: I18n.t('activemodel.user.error.email.required')
                    }
                }
            })

        },

        submit_data: function() {
            $comingSoon.on('click', '#submit_email', function () {
                if ($newUser.valid()) {
                    var survey_data = $qAndA.data();
                    var data = $userSurvey.val("");
                    $.each(survey_data, function (key, value) {
                        data = $userSurvey.val();
                        var updated_data = data.concat("{" + key + "=> " + value + "}");
                        $userSurvey.val(updated_data);
                    });
                }
            })
        }

    };

    if (!event_handlers.show_notice()){
        event_handlers.select_answer();
        event_handlers.validate_email_form();
        event_handlers.submit_data();
    }
});

$(function(){
    MEZZOE();
});