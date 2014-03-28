'use strict';

var answer, previous_id, question,
    start_questions = I18n.t('survey.questions.start_question'),
    btns = $('.btn'),
    question_div = $('.question'),
    pat = /^question_\d$/,
    survey_box = $('#survey'),
    digital_bool = 0;

var get_answer = function get_answer(btn){
    return $(btn).val().toLowerCase();
};

var get_question_id = function get_question_id(btn){
    var question = $(btn).siblings('.question');
    return question.attr('id');
};

var show_next_question = function next_question(answer, previous_id){

    if (answer == 'yes'){digital_bool = '1'}else{ digital_bool = '0'}
    question = I18n.t("survey.questions." + answer + "_to_" + previous_id + ".question_" + previous_id + digital_bool);
    question_div.attr('id', previous_id + digital_bool);

    //  if question points to another start question, and make sure it actually exists
    if (question.match(pat) && start_questions.hasOwnProperty(question)){
        question_div.attr('id', question.match(/\d/));
        question = I18n.t("survey.questions.start_question." + question);
    }
    // if question points to the final question
    if (question == 'fin_question'){
        question = I18n.t("survey.questions.fin_question");
        question_div.attr('id', 'fin');
    }
    // if question points to the negative result -- refactor to show the sign up page
    if (question == 'fin_negative'){
        question = I18n.t("survey.questions.fin_negative");
    }
    // if question points to the sign up -- refactor to show the sign up page
    if (question == 'sign_up'){
        question = I18n.t('survey.questions.sign_up');
        btns.hide();
    }
    question_div.text(question);
};

var select_answer = function select_answer(){
    survey_box.on('click', '.btn', function(){
        answer = get_answer(this);
        previous_id = get_question_id(this);
        show_next_question(answer, previous_id);
    })
};

$(function(){
    select_answer();
});