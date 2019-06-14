json_results = []

for i in 0..23
    response = HTTParty.get("https://api.data.gov/ed/collegescorecard/v1/schools?2017.student.size__range=1000..&fields=2013.admissions.act_scores.midpoint.cumulative,2017.admissions.admission_rate.overall,2017.admissions.sat_scores.average.overall,school.name,id,school.city,school.state,school.school_url&_per_page=100&_page=#{i}&api_key=deIaU9zcTLnkqvdoTitoGr0AEGJwMXLrEXNidSsc", format: :plain)

    json_response = JSON.parse response, symbolize_names: true

    json_response[:results].each do |hash|
        json_results << hash
    end
end


json_results.each do |data|
    College.find_or_create_by(school_id: data[:id], name: data[:"school.name"], city: data[:"school.city"], state: data[:"school.state"], url: data[:"school.school_url"], admission_rate_overall_2017: data[:"2017.admissions.admission_rate.overall"], sat_scores_average_overall_2017: data[:"2017.admissions.sat_scores.average.overall"], act_scores_average_cumulative_2013: data[:"2013.admissions.act_scores.midpoint.cumulative"])
end


## iterate over array -- json_results -- to create arrays of attributes
## 

# college_names = json_results.map do |college|
#     college[:"school.name"]
# end
