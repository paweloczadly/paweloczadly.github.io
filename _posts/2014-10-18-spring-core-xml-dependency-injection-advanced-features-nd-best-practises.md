---
layout: post
title: "Spring core: XML Dependency Injection Advanced features nd Best Practises"
category: certs
tags: [spring, java]
---
{% include JB/setup %}

## Intro

This series contains my notes to Spring core exam. I will try update it continuously. In this post I will focus on best practises for ioc container.

## Quick notes

Quick notes about important things in this chapter

### Externalizing values into properties files

It is possible to add some values to properties files and reuse them between contexts.

Notice:

- lines **3** and **8-9**: import context schema
- line **11** defines properties file
- lines **14** and **16** use values from app.properties file

context.xml:
{% highlight xml linenos %}
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:context="http://www.springframework.org/schema/context"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="
         http://www.springframework.org/schema/beans
         http://www.springframework.org/schema/beans/spring-beans.xsd
         http://www.springframework.org/schema/context
         http://www.springframework.org/schema/context/spring-context.xsd">

       <context:property-placeholder location="sandbox/app.properties" />

       <bean id="book" class="sandbox.Book">
           <constructor-arg index="0" value="${author}" />
           <constructor-arg index="1">
               <value>${title}</value>
           </constructor-arg>
       </bean>

</beans>
{% endhighlight %}

app.properties:
{% highlight groovy %}
author="Pawel Oczadly"
title="blog"
{% endhighlight %}

### Import other context

It is possible to import another context.

Notice:

- line **2**: imports another context (application-context.xml)
- line **5**: reference to dataSource which doesn't exist in context.xml. However it is declared in application-context.xml

context.xml:
{% highlight xml linenos %}
<beans>
  <import resource="classpath:sandbox/application-context.xml" />

  <bean id="accountRepository" class="pl.oczadly.account.JdbcAccountRepository">
    <property name="dataSource" ref="dataSource" />
  </bean>
</beans>
{% endhighlight %}

### Bean definition inheritance

In case of having similar beans.

**Notice**: parent bean doesn't specify class.

{% highlight xml linenos %}
<beans>
  <!-- parent bean: -->
  <bean id="abstractRepository" abstract="true">
  	<property name="dataSource" ref="dataSource" />
  </bean>

  <!-- children override class -->
  <bean id="accountRepository" parent="abstractRepository"
  	class="rewards.internal.account.JdbcAccountRepository" />

  <bean id="restaurantRepository" parent="abstractRepository"
  	class="rewards.internal.restaurant.JdbcRestaurantRepository" />

  <bean id="rewardRepository" parent="abstractRepository"
  	class="rewards.internal.reward.JdbcRewardRepository"
</beans>
{% endhighlight %}

### Collections

It is possible to use collections in bean definition.

Notice:

- lines **3** and **8-9**: import utils schema
- lines **16-19**: anonymous bean which stores book collection

{% highlight xml linenos %}
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:util="http://www.springframework.org/schema/util"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="
         http://www.springframework.org/schema/beans
         http://www.springframework.org/schema/beans/spring-beans.xsd
         http://www.springframework.org/schema/util
         http://www.springframework.org/schema/util/spring-util.xsd">


    <bean id="inventory" class="sandbox.Inventory">
        <property name="books" ref="bookList"/>
    </bean>

    <util:list id="bookList" list-class="java.util.ArrayList">
        <ref bean="book1" />
        <ref bean="book2" />
    </util:list>

    <bean id="book1" class="sandbox.Book">
        <constructor-arg index="0" value="Adam Mickiewicz" />
        <constructor-arg index="1" value="Pan Tadeusz" />
    </bean>

    <bean id="book2" class="sandbox.Book">
        <constructor-arg index="0" value="Venkat Subramaniam" />
        <constructor-arg index="1" value="Programming in Groovy 2" />
    </bean>

</beans>
{% endhighlight %}

### SpEL

Spring Expression Language

Notice:

- line **3** sets value to 'Pawel Oczadly'
- line **5** sets value to system variable 'user.name'

{% highlight xml linenos %}
<beans>
  <bean id="b1" class="sandbox.Book">
    <constructor-arg index="0" value="#{ b2.author }" />
    <constructor-arg index="1">
      <value>#{ systemProperties['user.name'] }</value>
    </constructor-arg>
  </bean>

  <bean id="b2" class="sandbox.Book">
    <property name="author" value="Pawel Oczadly" />
    <property name="title" value="blog" />
  </bean>
</beans>
{% endhighlight %}
