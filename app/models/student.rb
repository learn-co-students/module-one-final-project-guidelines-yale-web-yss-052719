class Student < ActiveRecord::Base
    has_many :applications
    has_many :colleges, through: :applications

    # validates :first_name, :presence => true
    # validates :last_name, :presence => true

    def create_application_by_name(college_name)
        if college = College.find_by(name: college_name)
            if college.act_scores_average_cumulative_2013
                if college.act_scores_average_cumulative_2013 > self.act_score
                    type = "reach"
                elsif college.act_scores_average_cumulative_2013 + 3 < self.act_score
                    type = "safety"
                else
                    type = "target"
                end
            elsif college.sat_scores_average_overall_2017
                if college.sat_scores_average_overall_2017 > self.sat_score
                    type = "reach"
                elsif college.sat_scores_average_overall_2017 + 3 < self.sat_score
                    type = "safety"
                else
                    type = "target"
                end
            else
                type = "no designation"
            end
            Application.create(student_id: self.id, college_id: college.id, designation: type)
        end
    end

    def create_application_by_school_id(school_id)
        if college = College.find_by(school_id: school_id)
            if college.act_scores_average_cumulative_2013
                if college.act_scores_average_cumulative_2013 > self.act_score
                    type = "reach"
                elsif college.act_scores_average_cumulative_2013 + 3 < self.act_score
                    type = "safety"
                else
                    type = "target"
                end
            elsif college.sat_scores_average_overall_2017
                if college.sat_scores_average_overall_2017 > self.sat_score
                    type = "reach"
                elsif college.sat_scores_average_overall_2017 + 3 < self.sat_score
                    type = "safety"
                else
                    type = "target"
                end
            else
                type = "no designation"
            end
            Application.create(student_id: self.id, college_id: college.id, designation: type)
        end
    end

    def find_target_colleges_by_act_score
        colleges = College.all.select do |college|
            college.act_scores_average_cumulative_2013
        end

        target_colleges = []

        colleges.each do |college|
            upper_limit = college.act_scores_average_cumulative_2013 + 3
            lower_limit = college.act_scores_average_cumulative_2013
            if self.act_score <= upper_limit && self.act_score >= lower_limit
                target_colleges << college
            end
        end

        target_colleges.sample(3)
    end

    def find_target_colleges_by_sat_score
        colleges = College.all.select do |college|
            college.sat_scores_average_overall_2017
        end

        target_colleges = []

        colleges.each do |college|
            upper_limit = college.sat_scores_average_overall_2017 + 150
            lower_limit = college.sat_scores_average_overall_2017
            if self.sat_score <= upper_limit && self.sat_score >= lower_limit
                target_colleges << college
            end
        end

        target_colleges.sample(3)
    end

    def find_reach_colleges_by_act_score
        colleges = College.all.select do |college|
            college.act_scores_average_cumulative_2013
        end

        reach_colleges = []

        colleges.each do |college|
            if self.act_score < college.act_scores_average_cumulative_2013
                reach_colleges << college
            end
        end

        reach_colleges.sample(3)
    end

    def find_reach_colleges_by_sat_score
        colleges = College.all.select do |college|
            college.sat_scores_average_overall_2017
        end

        reach_colleges = []

        colleges.each do |college|
            if self.sat_score < college.sat_scores_average_overall_2017
                reach_colleges << college
            end
        end

        reach_colleges.sample(3)
    end

    def find_safety_colleges_by_act_score
        colleges = College.all.select do |college|
            college.act_scores_average_cumulative_2013
        end

        safety_colleges = []

        colleges.each do |college|
            if self.act_score > college.act_scores_average_cumulative_2013 + 3
                safety_colleges << college
            end
        end

        safety_colleges.sample(3)
    end

    def find_safety_colleges_by_sat_score
        colleges = College.all.select do |college|
            college.sat_scores_average_overall_2017
        end

        safety_colleges = []

        colleges.each do |college|
            if self.sat_score > college.sat_scores_average_overall_2017 + 150
                safety_colleges << college
            end
        end

        safety_colleges.sample(3)
    end
end