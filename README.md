# SQL_HW - Pewlett-Hackard-Analysis

## Overview of the analysis:

Pewlet-Hackard’s (PH’s) human resource department are anticipating staffing and expertise vacancies as many of their employees approach retirement age. Not only do they need to plan their retirement packages, but they need to plan for future staffing.  

PH wants to ensure that they not only fill the upcoming positions, but they are filled with qualified candidates. 
  1) So, initially, we were asked to identify who will be retiring and how many will be retiring by skill set? 
  2) Furthermore, they want to explore the idea of creating a mentorship program to pass the baton of years of experience and skills to the next generation. 

Moving away from the excel files containing their employee information, HP decided to upgrade by creating an employee database using PostgreSQL to strategically plan for their “silver tsunami”.  PostgreSQL is a free and open-source relational database system. As one of the data analysts tasked with this project, I was able to take the original six spreadsheets, convert them to csv files to be imported into tables utilizing the Structure Query Language (SQL). By assigning primary and foreign keys, we were able to join the tables and create queries to create more tables to address the staffing concerns.  

## Results:

The retirement_titles table is a list of current employees who will be retiring soon (born between 1952-1955). There are duplicate entries in the retirement_titles table because as a person is promoted, we will see them listed for each position they have held in the company. 
![Slide1](https://user-images.githubusercontent.com/82008319/127791484-f3f7f437-cadc-4f84-9f83-2b1c0653e3ee.JPG)

To address the duplicate entries in the retirement_titles table, we created the unique_titles table providing each current employee and their latest position (ie, latest skill set). In order, to get the query to pull the upcoming retirees and their latest positions, we sorted the position start date in descending order.
![Slide2](https://user-images.githubusercontent.com/82008319/127791496-a8207e01-64db-4bbf-9de7-fbe08bb05f03.JPG)
  
The retiring_titles table contains the total count of employees who are eligible for upcoming retirement by their job title. For example, there are 29,414 Senior Engineers, and 28,254 Senior Staff members so there are 63.8% of the 90,398 upcoming retirees who hold senior level positions. 
![Slide3](https://user-images.githubusercontent.com/82008319/127791512-866c20ff-3ef1-4e0e-8459-b3e6dd365e5b.JPG)
  
HR would like to establish a mentorship program to match our upcoming retirees who would act as our mentors with potential mentees. Hence, they requested we create a list of eligible employees housed in our mentorship_eligib table. The criteria established for the potential mentees was as simple as capturing all of the current employees born in 1965.
![Slide4](https://user-images.githubusercontent.com/82008319/127791518-5777a383-1da2-4037-bfe9-6d89228d7961.JPG)
  
## Summary:
  
Overall, it was wise for Pewlet-Hackard to complete this analysis. It appears that there are 90,398 employees between the ages of 64-69 that are eligible for retirement which is 35% of their workforce. Sixty-four percent of those retiring hold senior level positions. The distribution of titles of the retirees aligns with the distribution of titles of all other employees (those born after 1955). This indicates that the company will not lose all their senior level staff which is a good thing.
![Slide5](https://user-images.githubusercontent.com/82008319/127791526-ed23258d-4e60-4c43-8f48-3225beaf0250.JPG)

However, they are still losing approximately 33% of their senior staff, so it is still wise to establish a mentorship program to not lose the wisdom of those retiring. As well, there are certainly more mentors available than mentees if all of the retirees become mentors and the only eligible mentees are those born in 1965. So, the criteria of the mentee eligibility should be revisited. 
![Slide6](https://user-images.githubusercontent.com/82008319/127791532-c6af1116-8e82-4593-93d3-8c1509161ee7.JPG)

<b>The summary detail was collected with the following five queries and created tables:</b>

From the first query we pulled to identify potential mentees, we decided to pull those employees born in 1965. There were 1,549 employees who are were born in 1965, aged 55-56. Hence, we would only match 1.7% of the upcoming retirees with available mentees. If we focused on the senior level positions, there would be a 1.9% match. While we are not sure how many of these upcoming retirees would be willing to mentor, we should consider expanding the criteria for mentees to a wider range of employees by first expanding the age bracket as well as consider the skills people hold.
![Slide7](https://user-images.githubusercontent.com/82008319/127791543-075aa9ee-ae79-4517-8737-ce0f91daeef7.JPG)

For example, if we were to increase the query by the number of employees born 1961-1971, there would be a greater pull of mentees (75,319) to match with mentors (90,398) giving us an 83.3% match. If we were to focus on the senior level positions it would be even better with a 91.4% match.
![Slide9](https://user-images.githubusercontent.com/82008319/127791560-a7305ba8-62ae-4de6-be80-613ee2909386.JPG)

This count was derived from creating a separate current employee list of those who are between 50 to 60 years old.
![Slide8](https://user-images.githubusercontent.com/82008319/127791579-cdb33df7-9403-410d-a966-4b70f3f7cf97.JPG)

Of course, we could consider skill level and skill potential. There may be an employee who is younger but would be a great leader and would benefit from mentoring with a future retiree. We certainly would have a larger pool of mentees if we expanded to any employee born after 1955. 
![Slide11](https://user-images.githubusercontent.com/82008319/127791591-eba777a6-9426-47f5-87a2-3e2eada4c187.JPG)

The above table was derived from the of current list of employees born after 1955 (see below).
![Slide10](https://user-images.githubusercontent.com/82008319/127791649-1b1a48d3-a0a9-410b-8ce7-8b933757f644.JPG)



