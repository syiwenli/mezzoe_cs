'use strict';

var MEZZOE = (function(){
    var answer, previous_id, question,
        start_questions = I18n.t('survey.questions.start_question'),
        $btns = $('.btn'),
        $questionDiv = $('.question'),
        pat = /^question_\d$/,
        $surveyBox = $('#survey'),
        digital_bool = 0,
        $notice = $('.notice'),
        $qAndA = $('#q_and_a'),
        $coming_soon = $('#coming_soon'),
        $new_user = $('#new_user'),
        $user_survey = $('#user_survey'),

    show_notice = function show_notice(){
        if ($notice.size() > 0 ){
            $surveyBox.hide();
            return true;
        }
        else{
            return false;
        }
    },

    get_answer = function get_answer(btn){
        return $(btn).val().toLowerCase();
    },

    get_question_id = function get_question_id(){
        return $questionDiv.attr('id');
    },

    show_next_question = function next_question(answer, previous_id){

        if (answer == 'yes'){digital_bool = '1'}else{ digital_bool = '0'}
        question = I18n.t("survey.questions." + answer + "_to_" + previous_id + ".question_" + previous_id + digital_bool);
        $questionDiv.attr('id', previous_id + digital_bool);

        //  if question points to another start question, and make sure it actually exists
        if (question.match(pat) && start_questions.hasOwnProperty(question)){
            $questionDiv.attr('id', question.match(/\d/));
            question = I18n.t("survey.questions.start_question." + question);
        }
        // if question points to the final question
        if (question == 'fin_question'){
            question = I18n.t("survey.questions.fin_question");
            $questionDiv.attr('id', 'fin');
        }
        // if question points to the final result
        if (question == 'fin_negative' || question == 'fin_positive'){
            question = I18n.t("survey.questions." + question);
            $btns.hide();
            $coming_soon.removeClass('hidden').addClass('show_inline');
        }
        $questionDiv.text(question);
    },

    select_answer = function select_answer(){
        $surveyBox.on('click', '.btn', function(){
            answer = get_answer(this);
            previous_id = get_question_id();
            show_next_question(answer, previous_id);
            $qAndA.data(previous_id, answer);

        })
    },

    validate_email_form = function validate_email_form(){
        $new_user.validate({
            rules:{
                "user[email]": {
                    required: true,
                    email: true
                }
            },
            messages: {
                "user[email]": {
                    required: I18n.t('activemodel.user.error.email.required'),
                    email: I18n.t('activemodel.user.error.email.format')
                }
            }
        })

    },

    submit_data = function submit_data(){
        $coming_soon.on('click', '#submit_email', function(){
            if ($new_user.valid()){
                var survey_data = $qAndA.data();
                var data = $user_survey.val("");
                $.each(survey_data, function(key,value){
                    data = $user_survey.val();
                    var updated_data = data.concat("{"+ key + "=> " + value+ "}");
                    $user_survey.val(updated_data);
                });
            }
        })
    };

    //reveal public API
    return{
        showNotice: show_notice,
        selectAnswer: select_answer,
        validateEmailForm: validate_email_form,
        submitData: submit_data
    };

}());

$(function(){
    if (!MEZZOE.showNotice()){
        MEZZOE.selectAnswer();
        MEZZOE.validateEmailForm();
        MEZZOE.submitData();
    }
});