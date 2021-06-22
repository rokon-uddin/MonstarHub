Feature: User want to show trending repositories of github by daily, weekly and
         monthly category bases.
         
     Scenario Outline:
           Given the user select <index> no category
           
           When the user select the category segment
           Then user should get the repositories by category
           
           Examples:
               | category| index |
               |    daily|     0 |
               |   weekly|     1 |
               |  monthly|     2 |
           
