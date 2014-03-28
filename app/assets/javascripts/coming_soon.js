'use strict';

console.log(I18n.t('hello'));
var get_question_id = function get_question_id(btn){
    var question = btn.siblings('.question');
    return question.attr('id');
};

var get_answer = function get_answer(btn){
    return $(btn).val();
};

var show_next_question = function next_question(answer){
    if (answer == 'Yes' ){

    }
};