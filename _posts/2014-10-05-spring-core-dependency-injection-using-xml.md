---
layout: post
title: "Spring-core: Dependency Injection using XML"
category: certs
tags: [spring, java]
comments: true
share: true
---

## Intro

This series contains my notes to Spring core exam. I will try update it continuously. In this post I will focus on ioc container, xml configuration and bean creation.

## Domain

Let's suppose that we have the following class:

{% highlight java %}
package pl.oczadly.account.model;

class Account {

  private int number;

  public Account(int number) {
    this.number = number;
  }

  // default constructor, setter and getter...

}
{% endhighlight %}

## Quick notes

Quick notes about important things in this chapter

### Two kind of xml contexts

- ```ClassPathXmlApplicationContext```

Usage:
{% highlight java %}
// for many config files (context.xml in package pl.oczadly):
ApplicationContext context1 = new ClassPathXmlApplicationContext("pl/oczadly/context.xml", "pl/oczadly/config/test-context.xml", "file:oracle-infra-config.xml");

// for one:
ApplicationContext context2 = new ClassPathXmlApplicationContext("context.xml");
{% endhighlight %}
- ```FileSystemXmlApplicationContext```

### Creating beans

{% highlight java %}
// cast required
ClientService cs1 = (ClientService) context.getBean("clientService");

// since Spring 3.0: no cast required
ClientService cs2 = context.getBean("clientService", ClientService.class);

// since Spring 3.0: must have unique type
ClientService cs3 = context.getBean(ClientService.class)
{% endhighlight %}

## Potential problems

This section contains potential strange questions...

### No default constructor

- **Problem**: bean declaration in xml without constructor injection. However, the class doesn't have default constructor.
- **Result**: BeanCreationException
- Example:

If we don't create default constructor and will try to create a bean with it:

{% highlight xml %}
<bean id="account" class="pl.oczadly.account.model.Account" />
{% endhighlight %}

We will get the following exception:

```
org.springframework.beans.factory.BeanCreationException: Error creating bean with name 'account' defined in class path resource [application-context.xml]: Instantiation of bean failed; nested exception is org.springframework.beans.BeanInstantiationException: Could not instantiate bean class [pl.oczadly.account.model.Account]: No default constructor found;
```

### One argument in two-args constructor

- **Problem**: a class contains two or more arguments in constructor. In xml bean is specified but not all constructor-args are declared.
- **Result**: UnsatisfiedDependencyException
- Example:

Let's modify the Account class by adding to it **owner** property and putting it into constructor. Now, it looks like this:

{% highlight java %}
package pl.oczadly.account.model;

class Account {

  private String owner;

  private int number;

  public Account(String owner, int number) {
    this.owner = owner;
    this.number = number;
  }

  // setters and getters...

}
{% endhighlight %}

Here is bean definition in xml:

{% highlight xml %}
<bean id="account" class="pl.oczadly.account.model.Account">
  <constructor-arg value="123456789" />
</bean>
{% endhighlight %}

Output:

```
org.springframework.beans.factory.BeanCreationException: Error creating bean with name 'account1' defined in class path resource [application-context.xml]: Could not resolve matching constructor (hint: specify index/type/name arguments for simple parameters to avoid type ambiguities)
```


### Two or more beans with the same id

- **Problem**: two beans in xml with the same id
- **Result**: BeanDefinitionParsingException
- Example:

{% highlight xml %}
<beans>
  <bean id="account" class="pl.oczadly.account.model.Account">
    <property name="number" value="123456789" />
  </bean>

  <bean id="account" class="pl.oczadly.account.model.Account">
    <property name="number" value="123456789" />
  </bean>

  <!-- other beans... -->
</beans>
{% endhighlight %}

Output:

```
Exception in thread "main" org.springframework.beans.factory.parsing.BeanDefinitionParsingException: Configuration problem: Bean name 'account' is already used in this <beans> element
```

### Value conversion

- **Problem**: specify integer value in double quotes
- **Result**: NumberFormatException
- Example:

{% highlight xml %}
<beans>
  <bean id="account" class="pl.oczadly.account.model.Account">
    <property name="number">
      <value>"123456789"</value>
    </property>
  </bean>

  <!-- other beans... -->
</beans>
{% endhighlight %}

{% highlight java %}
context.getBean(Account.class);
{% endhighlight %}

Output:

```
Caused by: java.lang.NumberFormatException: For input string: ""123456789""
```

**Correct**:
{% highlight xml %}
<bean id="account" class="pl.oczadly.account.model.Account">
  <property name="number" value="123456789" />
</bean>
{% endhighlight %}

### Creating two instances of Account class

- **Problem**: declare two Account beans in xml. Then use **getBean(Account.class)**
- **Result**: NoUniqueBeanDefinitionException
- Example:

Let's suppose that we have two Account beans:

{% highlight xml %}
<bean id="account1" class="pl.oczadly.account.model.Account">
  <property name="number" value="123456789" />
</bean>

<bean id="account2" class="pl.oczadly.account.model.Account">
  <property name="number" value="987654321" />
</bean>
{% endhighlight %}

and we want to instantiate them using **getBean(Account.class)** method:

{% highlight java %}
context.getBean(Account.class);
{% endhighlight %}

Then we get the following output:

```
Exception in thread "main" org.springframework.beans.factory.NoUniqueBeanDefinitionException: No qualifying bean of type [pl.oczadly.account.model.Account] is defined: expected single matching bean but found 2: account1,account2
```

### Creating bean with incorrect property

- **Problem**: declare a bean with incorrect property
- **Result**: BeanCreationException
- Example:

{% highlight xml %}
<bean id="account1" class="pl.oczadly.account.model.Account">
  <property name="incorrect" value="exception" />
</bean>
{% endhighlight %}

Output:

```
WARNING: Exception encountered during context initialization - cancelling refresh attempt
org.springframework.beans.factory.BeanCreationException: Error creating bean with name 'account1' defined in class path resource [application-context.xml]: Error setting property values; nested exception is org.springframework.beans.NotWritablePropertyException: Invalid property 'incorrect' of bean class [pl.oczadly.account.model.Account]: Bean property 'incorrect' is not writable or has an invalid setter method. Does the parameter type of the setter match the return type of the getter?
```
