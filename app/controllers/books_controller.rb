require 'google_books'

class BooksController < ApplicationController
  
  def index
    @book = Book.new
    @books = Book.all
    render 'index'
  end
  
  def google_book_search
    googleBooks = GoogleBooks::API.search params[:search]
    if googleBooks.total_results > 0
      googleBook = googleBooks.first
      book = Book.new :title => googleBook.title, :author => googleBook.authors.join('; '), :year => googleBook.published_date[0, 4]
      render :inline => book.to_json
    else 
      render :inline => ''
    end
  end
  
  def edit
    @book = Book.find params[:id]
    @books = Book.all
    render "index"
  end
  
  def create
    book = Book.new params[:book]
    if book.valid? and book.save
      redirect_to books_path, :notice => "The book you created was saved"
    else
      prepareForRender book, "Please ensure your fields are complete"
      render "index"
    end
  end
  
  def destroy
    Book.destroy params[:id]
    redirect_to books_path, :notice => "The book has been deleted"
  end
  
  def update
    book = Book.find params[:id]
    if book.update_attributes params[:book]
      redirect_to books_path, :notice => "Your book was updated"
    else
      prepareForRender book, "There was an error updating your book"
      render "index"
    end
  end
  
  def prepareForRender book, notice
    @book = book
    @books = Book.all
    flash[:notice] ||= []
    flash[:notice] << notice
  end
end
