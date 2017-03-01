defmodule BlogSearchTest do
  use ExUnit.Case
  doctest BlogSearch

  @document_text String.split("This is a short text But still this is a text")

  @corpus [String.split("This is a short text But still this is a text"),
           String.split("This is another text"),
           String.split("My name is Elias"),
           String.split("Is this good enough"),
           String.split("Do I really need to type ten of these"),
           String.split("There is no meaning for it"),
           String.split("I'll just type what you dictate"),
           String.split("Okay, we' re almost there actually. haha"),
           String.split("One two three four five six seven eight"),
           String.split("Two more please"),
         ]
  test "calculate the term frequency of the document passed" do
   assert BlogSearch.calculate_tfs(@document_text) == %{"a" => 2, "but" => 1, "is" => 2, "short" => 1, "still" => 1, "text" => 2, "this" => 2}
  end

  test "calculate the inverse document frequency of the word" do
    result =  BlogSearch.calculate_idfs(@corpus, ["this", "elias", "dictate", "text", "is", "these"])
    assert result["elias"] > result["is"]
    assert result["this"] > result["is"]
  end

  test "calculate tf-idf" do
    tfidf = BlogSearch.calculate_tfidf(@corpus)
    assert length(tfidf) == 10
  end

  test "create index" do
    #TODO
    index = BlogSearch.create_index(@corpus)
  end
end
