with person as (
    select *
    from {{ ref('stg_person')}}
)

, customers as (
    select *
    from {{ ref('stg_customer') }}
)

, transformed as (
    select
        row_number () over (order by customers.customer_id) as customerid_sk -- auto-incremental surrogate key									
        , customers.customer_id
        , person.persontype				
        , person.title				
        , person.firstname				
        , person.middlename
        , person.lastname				
        , person.full_name
    from customers
    left join person on customers.customer_id = person.person_id    
)

/* quando rodamos customer_id contra person_id, o modelo gera uma tabela, mas quando rodamos personid com person_id ele nao consegue fazer match
left join person on customers.personid = person.person_id
*/

select *
from transformed

/*
select count(distinct businessentity_sk)
from transformed;



select count(distinct businessentityid)
from {{ ref('stg_person')}};

total = 19972


select count(distinct customerid)
from {{ ref('stg_customer')}}

total = 19820
*/