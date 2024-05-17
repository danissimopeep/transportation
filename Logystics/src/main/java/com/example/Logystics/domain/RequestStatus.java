package com.example.Logystics.domain;

public enum RequestStatus {
    ACTIVE,
    START,
    PROCESSING,
    PACKING,
    NEED_INFO,
    DELIVERING,
    CANCELLED,
    DONE;
    public Integer getIntValue(){
        Integer value = -1;
        switch (this){
            case ACTIVE:{
                value = 0;
                break;
            }
            case START:{
                value = 1;
                break;
            }
            case PROCESSING:{
                value = 2;
                break;
            }
            case PACKING:{
                value = 3;
                break;
            }
            case NEED_INFO:{
                value = 4;
                break;
            }
            case DELIVERING:{
                value = 5;
                break;
            }
            case CANCELLED:{
                value = 6;
                break;
            }
            case DONE:{
                value = 7;
                break;
            }
        }
        return value;
    }
    public String getStrValue(){
        String value = "";
        switch (this){
            case ACTIVE:{
                value = "Активен";
                break;
            }
            case START:{
                value = "Начат";
                break;
            }
            case PROCESSING:{
                value = "Обрабатывается";
                break;
            }
            case PACKING:{
                value = "Готовится";
                break;
            }
            case NEED_INFO:{
                value = "Нужна информация";
                break;
            }
            case DELIVERING:{
                value = "Доставляется";
                break;
            }
            case CANCELLED:{
                value = "Отменен";
                break;
            }
            case DONE:{
                value = "Закончен";
                break;
            }
        }
        return value;
    }

    public static RequestStatus getStatusFromInt(Integer value){
        RequestStatus status = RequestStatus.ACTIVE;
        switch (value){
            case 0:{
                status = RequestStatus.ACTIVE;
                break;
            }
            case 1:{
                status = RequestStatus.START;
                break;
            }
            case 2:{
                status = RequestStatus.PROCESSING;
                break;
            }
            case 3:{
                status = RequestStatus.PACKING;
                break;
            }
            case 4:{
                status = RequestStatus.NEED_INFO;
                break;
            }
            case 5:{
                status = RequestStatus.DELIVERING;
                break;
            }
            case 6:{
                status = RequestStatus.CANCELLED;
                break;
            }
            case 7:{
                status = RequestStatus.DONE;
                break;
            }
        }

        return status;
    }
}
