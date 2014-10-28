---
layout: post
title: "Spring Core: Dependency Injection using Java Configuration"
category: "dev"
tags: [spring, java]
comments: true
share: true
---
# Intro

This series contains my notes to Spring core exam. I will try update it continuously. In this post I will focus on dependency injection using Java configuration.

# Quick notes

Quick notes about important things in this chapter.

## Creating beans using Java configuration

Let's suppose that we have similar structure as in previous post:

{% highlight bash %}
sandbox
|-- AppConfig.java
|-- AccountRepository.java
|-- JdbcAccountRepository.java
|-- Main.java
|-- TransferService.java
`-- TransferServiceImpl.java
{% endhighlight %}

Here is the implementation of **AppConfig** class:

{% highlight java linenos %}
package sandbox;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class AppConfig {

  @Bean()
  public TransferService transferService() {
    TransferService transferService = new TransferServiceImpl();
    ((TransferServiceImpl)transferService).setRepo(repository());
    return transferService;
  }

  @Bean(name = "accountRepository")
  public AccountRepository repository() {
    return new JdbcAccountRepository();
  }

}
{% endhighlight %}

Please, note:

- line **6** the same as in Spring annotations
- lines **9** and **16** declares two beans: transferService and accountRepository
- line **16** specifies bean id

The above configuration is the same as the following xml:

{% highlight xml linenos %}
<beans>
  <bean id="transferService" class="sandbox.TransferServiceImpl">
    <property name="repo" ref="accountRepository" />
  </bean>

  <bean id="accountRepository" class="sandbox.JdbcAccountRepository" />
</beans>
{% endhighlight %}
