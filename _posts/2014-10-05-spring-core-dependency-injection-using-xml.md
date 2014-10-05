---
layout: post
title: "Spring-core: Dependency Injection using XML"
category: certs
tags: [spring, java]
---
{% include JB/setup %}

## Spring-core: Dependency Injection using XML

This series contains my notes to Spring core exam. I will try update it continuously. In this post I will focus on ioc container, xml configuration and bean creation.

## Domain

Let's suppose that we have the following class:

{% highlight java %}
package pl.oczadly;

class Account {

  private int number;

  public Account(int number) {
    this.number = number;
  }

  // default constructor, setter and getter...

}
{% endhighlight %}

## No default constructor

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

## Two or more beans with the same id

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

## Value conversion

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

## Creating two instances of Account class

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

## Creating bean with incorrect property

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
