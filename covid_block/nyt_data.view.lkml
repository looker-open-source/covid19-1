include: "//@{CONFIG_PROJECT_NAME}/covid_block/nyt_data.view.lkml"

### This view contains the NYT county level data, coming from BQ public datasets

view: nyt_data {
  extends: [nyt_data_config]
}

###################################################


view: nyt_data_core {
  extension: required
  derived_table: {
    sql: select * except(county, county_fips_code),
           case when county = 'Unknown' then concat(county,' - ',state_name) else county end as county,
            case when county = 'Unknown'then NULL
                --mofifying the FIPS code to match other data
                when county = 'New York City' then 36125
                when county = 'Kansas City' then 29095
                else cast(county_fips_code as int64) end as fips
        from `bigquery-public-data.covid19_nyt.us_counties`;;
    sql_trigger_value: SELECT COUNT(*) FROM `bigquery-public-data.covid19_nyt.us_counties` ;;
  }

}
