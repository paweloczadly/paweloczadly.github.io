---
layout: post
title: "Spring core: Annotations"
category: certs
tags: [spring, java]
comments: true
share: true
---
# Intro

This series contains my notes to Spring core exam. I will try update it continuously. In this post I will focus on best practises for ioc container.

# Quick notes

Quick notes about important things in this chapter

## Creating beans using annotations

In this case we have **sandbox** package and the following classes:

{% highlight bash %}
sandbox
|-- AccountRepository.java
|-- JdbcAccountRepository.java
|-- Main.java
|-- TransferService.java
`-- TransferServiceImpl.java
{% endhighlight %}

Here we have two classes:

- JdbcAccountRepository
- TransferServiceImpl

They use annotations: **@Component** and **@Autowired** for dependency injection.

{% highlight java linenos %}
package sandbox;

import org.springframework.stereotype.Component;

@Component
public class JdbcAccountRepository implements AccountRepository {
  @Override
  public void save() {
    System.out.println("Saving money....");
  }
}
{% endhighlight %}

{% highlight java linenos %}
package sandbox;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class TransferServiceImpl implements TransferService {
  private AccountRepository repo;

  @Override
  public void transfer() {
    System.out.println("Transfer...");
    repo.save();
  }

  public AccountRepository getRepo() {
    return repo;
  }

  @Autowired
  public void setRepo(AccountRepository repo) {
    this.repo = repo;
  }
}
{% endhighlight %}

### Instantiation

#### Without xml

To instantiate **TransferService** we can use **AnnotationConfigApplicationContext** class and pass packages names or classes to it. For example:

{% highlight java %}
ApplicationContext context = new AnnotationConfigApplicationContext("sandbox");
{% endhighlight %}

#### Annotations + xml (component-scan)

We can also have a xml context file. Inside it we have to specify packages inside **<component-scan>**. Example:

{% highlight xml linenos %}
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="
        http://www.springframework.org/schema/beans
        http://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/context
        http://www.springframework.org/schema/context/spring-context.xsd">

        <context:component-scan base-package="sandbox" />


</beans>
{% endhighlight %}

Please, note:

- lines **4** and **8-9** imports *context* schema
- line **11** tells Spring that **@Component** classes are in **sandbox** package

#### Annotations + xml (annotation-config)

In this case we can remove **@Component** annotation from our classes. Instead of them we have to declare our beans in xml. Note that we don't need to specify ```<property>``` for **transferService** bean. It is done by **@Autowired** annotation. Example:

{% highlight xml linenos %}
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="
        http://www.springframework.org/schema/beans
        http://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/context
        http://www.springframework.org/schema/context/spring-context.xsd">

        <context:annotation-config />

        <bean id="transferService" class="sandbox.TransferServiceImpl" />
        <bean id="accountRepository" class="sandbox.JdbcAccountRepository" />

</beans>
{% endhighlight %}
